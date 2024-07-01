class Egctl < Formula
  desc "Command-line utility for operating Envoy Gateway"
  homepage "https:gateway.envoyproxy.io"
  url "https:github.comenvoyproxygatewayarchiverefstagsv1.0.2.tar.gz"
  sha256 "05406182dc165513925cf60722582613d4de9ea789d60e014e6da456bb229f65"
  license "Apache-2.0"
  head "https:github.comenvoyproxygateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "442ef19cd8d4abd3929ce289e8259b4618e915fe076a0b28cb433a83e83ee345"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98026117b40295bd0dbccde6d7d5483669ed0cce00c66432712bd1631b809839"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "babab75268c48dd69cea1ded164a70e3c3fb63af258b488b7c6d58653f40bb60"
    sha256 cellar: :any_skip_relocation, sonoma:         "c39ebd95cad867bc1b8612f8ced46628f8598468258b63dd3254885733311dd4"
    sha256 cellar: :any_skip_relocation, ventura:        "2283eeb99931b79594b94f3c93ba50b03cb8af69643d174ce31614414b843c97"
    sha256 cellar: :any_skip_relocation, monterey:       "2789de921dd337393c43f85b2e808a35214f12f24f53505b8f72e31371f2f2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e623e4318e5e60496222dbfaee3fe4c7a6ee885d0b5875b5551ea730b87b49d5"
  end

  depends_on "go" => :build

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
                name: defaulteghttpwww_example_com
                routes:
                - match:
                    prefix: 
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