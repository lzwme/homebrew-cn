class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/website/docs/gator"
  url "https://ghproxy.com/https://github.com/open-policy-agent/gatekeeper/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "915cb6b97d5449515dce939679a37a7c011b3495442c7d028f3856324dee0afb"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/gatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "280b4d53e6f61df1e9de336c65c40256c5fdabce7f62cb59ff1f58fbecab0703"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "280b4d53e6f61df1e9de336c65c40256c5fdabce7f62cb59ff1f58fbecab0703"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "280b4d53e6f61df1e9de336c65c40256c5fdabce7f62cb59ff1f58fbecab0703"
    sha256 cellar: :any_skip_relocation, ventura:        "843a8ac828b8add4d6cfe8361bdbe7947f8386f2952661e25950c46edfe3a57b"
    sha256 cellar: :any_skip_relocation, monterey:       "843a8ac828b8add4d6cfe8361bdbe7947f8386f2952661e25950c46edfe3a57b"
    sha256 cellar: :any_skip_relocation, big_sur:        "843a8ac828b8add4d6cfe8361bdbe7947f8386f2952661e25950c46edfe3a57b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "267ea4d520bec29f509af003ec03c128b247cf3d3e8e34adb87d2b2f12a479b5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/gatekeeper/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gator"

    generate_completions_from_executable(bin/"gator", "completion")
  end

  test do
    assert_match "gator is a suite of authorship tools for Gatekeeper", shell_output("#{bin}/gator -h")

    # Create a test manifest file
    (testpath/"gator-manifest.yaml").write <<~EOS
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      metadata:
        name: ingress-demo-disallowed
        annotations:
          kubernetes.io/ingress.allow-http: "false"
      spec:
        tls: [{}]
        rules:
          - host: example-host.example.com
            http:
              paths:
              - pathType: Prefix
                path: "/"
                backend:
                  service:
                    name: nginx
                    port:
                      number: 80
    EOS
    # Create a test constraint template
    (testpath/"template-and-constraints/gator-constraint-template.yaml").write <<~EOS
      apiVersion: templates.gatekeeper.sh/v1
      kind: ConstraintTemplate
      metadata:
        name: k8shttpsonly
        annotations:
          description: >-
            Requires Ingress resources to be HTTPS only.
            Ingress resources must:
            - include a valid TLS configuration
            - include the `kubernetes.io/ingress.allow-http` annotation, set to
              `false`.
            https://kubernetes.io/docs/concepts/services-networking/ingress/#tls
      spec:
        crd:
          spec:
            names:
              kind: K8sHttpsOnly
        targets:
          - target: admission.k8s.gatekeeper.sh
            rego: |
              package k8shttpsonly
              violation[{"msg": msg}] {
                input.review.object.kind == "Ingress"
                re_match("^(extensions|networking.k8s.io)/", input.review.object.apiVersion)
                ingress := input.review.object
                not https_complete(ingress)
                msg := sprintf("Ingress should be https. tls configuration and allow-http=false annotation are required for %v", [ingress.metadata.name])
              }
              https_complete(ingress) = true {
                ingress.spec["tls"]
                count(ingress.spec.tls) > 0
                ingress.metadata.annotations["kubernetes.io/ingress.allow-http"] == "false"
              }
    EOS
    # Create a test constraint file
    (testpath/"template-and-constraints/gator-constraint.yaml").write <<~EOS
      apiVersion: constraints.gatekeeper.sh/v1beta1
      kind: K8sHttpsOnly
      metadata:
        name: ingress-https-only
      spec:
        match:
          kinds:
            - apiGroups: ["extensions", "networking.k8s.io"]
              kinds: ["Ingress"]
    EOS

    assert_empty shell_output("#{bin}/gator test -f gator-manifest.yaml -f template-and-constraints/")
  end
end