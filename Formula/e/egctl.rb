class Egctl < Formula
  desc "Command-line utility for operating Envoy Gateway"
  homepage "https:gateway.envoyproxy.io"
  url "https:github.comenvoyproxygatewayarchiverefstagsv1.2.3.tar.gz"
  sha256 "53d1b29a7b0700537864458509a6bbc0106777ba52e8f2107137cfc0855c8f14"
  license "Apache-2.0"
  head "https:github.comenvoyproxygateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de9645c154d65fa0e8f3596fc291657055561591832a92281e47e5b68b2da504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b1e79b03851b2e688f202488dbdd7fcf1d2eccf737e90a79c420a6c9c6c9ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "716151babedb05f2bc2cc9ced82c1fafadc1860bac0520a25c9866c75158cc49"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5893ce7201566c0207ca5f5e5e2c0347d5a6a1157783c107eddd6d8e0395e54"
    sha256 cellar: :any_skip_relocation, ventura:       "910349c2e0314489da7390fe458be24e956d14c7cdf754b730cb30fdf44aea3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bd7f5a38e1b9e3da25f262d80a214cc8fac3f923cda866b787540b59585586c"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.comenvoyproxygatewayinternalcmdversion.envoyGatewayVersion=#{version}
      -X github.comenvoyproxygatewayinternalcmdversion.gitCommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdegctl"

    generate_completions_from_executable(bin"egctl", "completion")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}egctl version --remote=false").strip

    (testpath"input.yaml").write <<~YAML
      apiVersion: gateway.networking.k8s.iov1
      kind: GatewayClass
      metadata:
        name: eg
      spec:
        controllerName: gateway.envoyproxy.iogatewayclass-controller
      ---
      apiVersion: gateway.networking.k8s.iov1
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
      apiVersion: gateway.networking.k8s.iov1
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
                  value: 
    YAML

    expected = <<~EOS
      xds:
        defaulteg:
          '@type': type.googleapis.comenvoy.admin.v3.RoutesConfigDump
          dynamicRouteConfigs:
          - routeConfig:
              '@type': type.googleapis.comenvoy.config.route.v3.RouteConfiguration
              ignorePortInHostMatching: true
              name: defaulteghttp
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
                name: defaulteghttpwww_example_com
                routes:
                - match:
                    prefix: 
                  metadata:
                    filterMetadata:
                      envoy-gateway:
                        resources:
                        - kind: HTTPRoute
                          name: backend
                          namespace: default
                  name: httproutedefaultbackendrule0match0www_example_com
                  route:
                    cluster: httproutedefaultbackendrule0
                    upgradeConfigs:
                    - upgradeType: websocket

    EOS

    output = shell_output("#{bin}egctl x translate --from gateway-api --to xds -t route -f #{testpath}input.yaml")
    assert_equal expected, output
  end
end