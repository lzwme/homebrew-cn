class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/website/docs/gator"
  url "https://ghproxy.com/https://github.com/open-policy-agent/gatekeeper/archive/refs/tags/v3.13.1.tar.gz"
  sha256 "c5764ab03253306de5e83da9122b08e4129e16549e5cad11b1c75b97e04c7c2c"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/gatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b48ed4cf3efc67c24f9c625ceb37c5a57d843325f73e544b0ce9240e5db60df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a0c0b2fa43ba74bb36c397dae9873361c3640c4345d258fa6737bc6cdf9ce20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bc1a1652588b6dc87434f8efff8ae06335fe28922cdba36af81b91500909f71"
    sha256 cellar: :any_skip_relocation, sonoma:         "00b4120cf03a238451ddd75783f05a9342c7ec25e94f946050d59c599421f505"
    sha256 cellar: :any_skip_relocation, ventura:        "1809a325b5f9b7dd599203856096c0bb523deebcb3f090508b843c55f1967bfd"
    sha256 cellar: :any_skip_relocation, monterey:       "d0ad3051301dbe62b3efbe57dd75d7e097e7e636d4b451fc6a197695244280f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "314045ce3506c3874f6bb23cf414b5b555d6a76ecd2f4bd01654af9ff69f9522"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/gatekeeper/v3/pkg/version.Version=#{version}
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

    assert_match version.to_s, shell_output("#{bin}/gator --version")
  end
end