class Egctl < Formula
  desc "Command-line utility for operating Envoy Gateway"
  homepage "https://gateway.envoyproxy.io/"
  url "https://ghfast.top/https://github.com/envoyproxy/gateway/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "a62c7c93202e8166ceb4cf136549f1cce9f7c3dc630dd68a7bc479845b2bb47b"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/gateway.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "281b57a4ebc174cfe6255cabc7d6d895df0eb6378e9837d3102a9d79e2f4e285"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "329233d2ac8ace26cf74948648b01cf1135b2fe2c6b21401585e795eba24098c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51c534b5f4b6998d5881aa04ad725d3d7805cd00f36b3015b16cdad6618c55e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c180bbcb74bf92e43ef934ba3b8c73f3900eff5f58873ea2129510bf2b5f4f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9418f4a2ccdb6a639d3f48a774d0b60df8af1b1aa8f763e6c4d61abf41f65c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26b2a9e718b515b3966a93a9f5ba4e24f6e7611e521c661f42a13fe59c489385"
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