class Egctl < Formula
  desc "Command-line utility for operating Envoy Gateway"
  homepage "https:gateway.envoyproxy.io"
  url "https:github.comenvoyproxygatewayarchiverefstagsv1.3.3.tar.gz"
  sha256 "54225f8a52a46efa423e034189e2971dea64437dc79c5205a0ba39475005d190"
  license "Apache-2.0"
  head "https:github.comenvoyproxygateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bd83e12dcfce64b2655abee020db6085697589af5e8f8d95b6fa60623d12d4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b061f4ef9a8fabc8dcf68b5d67f605f34adadfb89ce6ff3fec2ebf3ca642bf0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f4974dcc88dcd279531ab4a3cdc7d92e5f9be7beb1fe4fe89dfa857316e7f5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c0f2084eb058106d7dd0b1fa3d1070f4143b2bf6ab23f0b0e55cf3898452f57"
    sha256 cellar: :any_skip_relocation, ventura:       "d3c099041421c6c380a4ff26f256b8c3602290549282fa2f5fb64411e97dfae1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043f3e2707d07aaa3ce11bee498bf2e0d742d4e0bf808b111baf263db2abf93b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dad0eb0f80aa413577a2489c0d58fb9dab1d56ac44d6d23dca44573d88b52af"
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