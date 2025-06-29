class Egctl < Formula
  desc "Command-line utility for operating Envoy Gateway"
  homepage "https:gateway.envoyproxy.io"
  url "https:github.comenvoyproxygatewayarchiverefstagsv1.4.1.tar.gz"
  sha256 "325564511cbbd90ba3a674feaa88218c6f178323153a8921c5b4786441585cdb"
  license "Apache-2.0"
  head "https:github.comenvoyproxygateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d4b853eafc777fc2a268d51e646a83753d83a9960d0bc76da87e81a344c07c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7164f4f67f2b2dac75b5efbcc4f3de394b86379be85200f3ea2db067902dc36a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23aab29bbc30ac887830b22cbc1ee325a87cde562dbdd26df47927933d0f0142"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fd3bddb49fd0d8106ea9a9c9ef7ac592d3daa6e681aad0907d1ab62516538ff"
    sha256 cellar: :any_skip_relocation, ventura:       "0c44679a701a3bcda1cffa9ddd4e8225ddc45f6becf93d87b04fb9e561c9b79e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "954a6e6af1e3847567ee2b85d9299b1ddccdc7cb5f13cb2349cedda628909648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5cf93c224ef8c8a8996150d880c19d06ba840441efcba209ca6e4a19f775418"
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