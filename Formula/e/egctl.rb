class Egctl < Formula
  desc "Command-line utility for operating Envoy Gateway"
  homepage "https:gateway.envoyproxy.io"
  url "https:github.comenvoyproxygatewayarchiverefstagsv1.1.1.tar.gz"
  sha256 "4507d269bed5288ce90091209c08353083d89a8ccfff0fff563b3a59db804b7e"
  license "Apache-2.0"
  head "https:github.comenvoyproxygateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "050dfe989fffcfb8b43ca3cddd6f7fde1bd651ede7388d7c061c277d76ff767d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c50a94cb32f1fb1f81938b89b19e665e0021b9d8d74ddd5ecdab6ba3a67cd46b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd55bb30ee1f5f029d0405fb990432e4f5e587047bd2f933d862dcb466090494"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5226ad23430837d50710d7132a334459bd6a9689b1a9b5f9530307340fce1253"
    sha256 cellar: :any_skip_relocation, sonoma:         "db60dca9790ca140061d0983880eea75864390dda46195f029c3deef5acd896d"
    sha256 cellar: :any_skip_relocation, ventura:        "81f9fea669ad3ea4082958cc8603c38aaf4c1897e72a3695f6e1fb53b8ad489c"
    sha256 cellar: :any_skip_relocation, monterey:       "b983b5c656926e837d6b6a509e102497ccb29aa61a91eb75f240427de9d66a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9445f1d33072f5b640a08b7c59cea5494e7c74937249594c791445fb89f5bd"
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

    (testpath"input.yaml").write <<~EOS
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
    EOS

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
                      - kind: ""
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
    assert_equal output, expected
  end
end