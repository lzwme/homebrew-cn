class Egctl < Formula
  desc "Command-line utility for operating Envoy Gateway"
  homepage "https://gateway.envoyproxy.io/"
  url "https://ghfast.top/https://github.com/envoyproxy/gateway/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "aeb5d0f9f869f19836947bb03187abd3b3bebf58f20cf1c52b6a3f9b0510a384"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/gateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74bcfaeaf49698c4ccee6fe612ed76df5216abfbe7ac1e8a8bd642ae5b9efa82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b393280517bff82a4a84acb118260c772b98a94bae6f9d21bcbbc781d53215b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b58809b2aaee626dab9ffa84228b0f758b16fdf9379382b395eccd25fbb8e3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d3baf5118202c0557f9d984e4634aaaf6bbfc9e876c49606428019490679b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "190add40ffb29614f4ba51aacafcd598ef27871fd4f9db5733ac25e83423c7e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e301e06f16506193dda54d901bed0c2a4d27081d1256021eaae24ee4a1ebc4f"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/envoyproxy/gateway/internal/cmd/version.envoyGatewayVersion=#{version}
      -X github.com/envoyproxy/gateway/internal/cmd/version.gitCommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/egctl"

    generate_completions_from_executable(bin/"egctl", shell_parameter_format: :cobra)
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/egctl version --remote=false").strip

    (testpath/"input.yaml").write <<~YAML
      apiVersion: gateway.networking.k8s.io/v1
      kind: GatewayClass
      metadata:
        name: eg
      spec:
        controllerName: gateway.envoyproxy.io/gatewayclass-controller
      ---
      apiVersion: gateway.networking.k8s.io/v1
      kind: Gateway
      metadata:
        name: eg
        namespace: default
      spec:
        gatewayClassName: eg
        listeners:
          - name: http
            protocol: HTTP
            port: 80
      ---
      apiVersion: v1
      kind: Namespace
      metadata:
        name: default
      ---
      apiVersion: v1
      kind: Service
      metadata:
        name: backend
        namespace: default
        labels:
          app: backend
          service: backend
      spec:
        clusterIP: "1.1.1.1"
        type: ClusterIP
        ports:
          - name: http
            port: 3000
            targetPort: 3000
            protocol: TCP
        selector:
          app: backend
      ---
      apiVersion: gateway.networking.k8s.io/v1
      kind: HTTPRoute
      metadata:
        name: backend
        namespace: default
      spec:
        parentRefs:
          - name: eg
        hostnames:
          - "www.example.com"
        rules:
          - backendRefs:
              - group: ""
                kind: Service
                name: backend
                port: 3000
                weight: 1
            matches:
              - path:
                  type: PathPrefix
                  value: /
    YAML

    expected = <<~EOS
      xds:
        default/eg:
          '@type': type.googleapis.com/envoy.admin.v3.RoutesConfigDump
          dynamicRouteConfigs:
          - routeConfig:
              '@type': type.googleapis.com/envoy.config.route.v3.RouteConfiguration
              ignorePortInHostMatching: true
              name: default/eg/http
              virtualHosts:
              - domains:
                - www.example.com
                metadata:
                  filterMetadata:
                    envoy-gateway:
                      resources:
                      - kind: Gateway
                        name: eg
                        namespace: default
                        sectionName: http
                name: default/eg/http/www_example_com
                routes:
                - match:
                    prefix: /
                  metadata:
                    filterMetadata:
                      envoy-gateway:
                        resources:
                        - kind: HTTPRoute
                          name: backend
                          namespace: default
                  name: httproute/default/backend/rule/0/match/0/www_example_com
                  route:
                    cluster: httproute/default/backend/rule/0
                    upgradeConfigs:
                    - upgradeType: websocket

    EOS

    output = shell_output("#{bin}/egctl x translate --from gateway-api --to xds -t route -f #{testpath}/input.yaml")
    assert_equal expected, output
  end
end