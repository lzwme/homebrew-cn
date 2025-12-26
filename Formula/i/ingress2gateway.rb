class Ingress2gateway < Formula
  desc "Convert Kubernetes Ingress resources to Kubernetes Gateway API resources"
  homepage "https://github.com/kubernetes-sigs/ingress2gateway"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/ingress2gateway/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7c511e4c309b62d01ce2128643922637f0ca77524bab2c4c6811bebbb43ff119"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/ingress2gateway.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04f6588efa4dd83dc15982b8d5b01d0e8277d28e394092b05dd4a15c107f4250"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23e65c559979436b7ac7a5e97c36a4c11295b36f85fdd70e52d5dd869492db03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a08648e43d612dcd661cae2db2c37ac32f44905324f93671d9ac750269d9cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6adfe802ae0473b4dfeccad977f810a78d69e4e27a7dd6f173aec976527f1cc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51775975c980566a1ac2c74de42cf0532e810e5d8b072e8dce8ca5ffdb817996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd87e3f7ea0ad3345827af7335342dfe3cdfa856637334371af64da4d30e426c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ingress2gateway", shell_parameter_format: :cobra)
  end

  test do
    test_file = testpath/"test.yml"
    test_file.write <<~YAML
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      metadata:
        name: foo
        namespace: bar
        annotations:
          nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
          nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
          nginx.ingress.kubernetes.io/ssl-passthrough: "true"
          cert-manager.io/cluster-issuer: "letsencrypt-prod"
        labels:
          name: foo
      spec:
        ingressClassName: nginx
        rules:
        - host: foo.bar
          http:
            paths:
            - pathType: Prefix
              path: "/"
              backend:
                service:
                  name: foo-bar
                  port:
                    number: 443
        tls:
        - hosts:
          - foo,bar
          secretName: foo-bar-cert
    YAML

    expected = <<~YAML
      apiVersion: gateway.networking.k8s.io/v1
      kind: Gateway
      metadata:
        annotations:
          gateway.networking.k8s.io/generator: ingress2gateway-#{version}
        creationTimestamp: null
        name: nginx
        namespace: bar
      spec:
        gatewayClassName: nginx
        listeners:
        - hostname: foo.bar
          name: foo-bar-http
          port: 80
          protocol: HTTP
        - hostname: foo.bar
          name: foo-bar-https
          port: 443
          protocol: HTTPS
          tls:
            certificateRefs:
            - group: null
              kind: null
              name: foo-bar-cert
      status: {}
      ---
      apiVersion: gateway.networking.k8s.io/v1
      kind: HTTPRoute
      metadata:
        annotations:
          gateway.networking.k8s.io/generator: ingress2gateway-#{version}
        creationTimestamp: null
        name: foo-foo-bar
        namespace: bar
      spec:
        hostnames:
        - foo.bar
        parentRefs:
        - name: nginx
        rules:
        - backendRefs:
          - name: foo-bar
            port: 443
          matches:
          - path:
              type: PathPrefix
              value: /
      status:
        parents: []
    YAML

    result = shell_output("#{bin}/ingress2gateway\
                          print\
                          --providers ingress-nginx\
                          --input-file #{testpath}/test.yml\
                          -A")

    assert_equal expected.chomp, result.chomp
  end
end