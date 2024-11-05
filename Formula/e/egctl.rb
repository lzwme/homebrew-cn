class Egctl < Formula
  desc "Command-line utility for operating Envoy Gateway"
  homepage "https:gateway.envoyproxy.io"
  url "https:github.comenvoyproxygatewayarchiverefstagsv1.1.3.tar.gz"
  sha256 "061318e4c3daf8d85470fd77c84c09a87a55357512e1f1d749d2647c1a4ca4ad"
  license "Apache-2.0"
  head "https:github.comenvoyproxygateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "868f136e60b1d4e9f5467957a800d0bfaf5c31274a56a2b92fa524588444d2a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69c44a30a7191ef5e0e0a34c3a2ba1fceb8fc76b14a8e17819db1f9d730fa48f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73973cbf8fa4e3b6d3a447f0beea15679372551a8350ab56cb7571c42c562fb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3ec8d1ca3747edfe612a65349ef1cfb1fa0fffefef434785409243fbd5326be"
    sha256 cellar: :any_skip_relocation, ventura:       "9c1ae84fd5fea28039b73f244f4532264fd645e8c548b96573eb74c17cc38486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e02b056d012d9cc79a25460d381687ece0200876d3cab7bcff0c736702477061"
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