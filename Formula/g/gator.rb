class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https:open-policy-agent.github.iogatekeeperwebsitedocsgator"
  url "https:github.comopen-policy-agentgatekeeperarchiverefstagsv3.18.1.tar.gz"
  sha256 "7ee5a70d14c4356791ffbbc846766d487ea81af3d1bd990b1b78e219d6bcb7dc"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentgatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50078539a568f876774df083584a2e7295833b5b931f60c0c54099523a7efb8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50078539a568f876774df083584a2e7295833b5b931f60c0c54099523a7efb8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50078539a568f876774df083584a2e7295833b5b931f60c0c54099523a7efb8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f343cfa6ae5f90c9701162155b633db890d9df22adc820f96c6169d47b79baa1"
    sha256 cellar: :any_skip_relocation, ventura:       "f343cfa6ae5f90c9701162155b633db890d9df22adc820f96c6169d47b79baa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7574f268f864ae42986a31f06e5f2ffd2c1fa8653ae16d5cdadf5dcb641cfd76"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopen-policy-agentgatekeeperv3pkgversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdgator"

    generate_completions_from_executable(bin"gator", "completion")
  end

  test do
    assert_match "gator is a suite of authorship tools for Gatekeeper", shell_output("#{bin}gator -h")

    # Create a test manifest file
    (testpath"gator-manifest.yaml").write <<~YAML
      apiVersion: networking.k8s.iov1
      kind: Ingress
      metadata:
        name: ingress-demo-disallowed
        annotations:
          kubernetes.ioingress.allow-http: "false"
      spec:
        tls: [{}]
        rules:
          - host: example-host.example.com
            http:
              paths:
              - pathType: Prefix
                path: ""
                backend:
                  service:
                    name: nginx
                    port:
                      number: 80
    YAML
    # Create a test constraint template
    (testpath"template-and-constraintsgator-constraint-template.yaml").write <<~YAML
      apiVersion: templates.gatekeeper.shv1
      kind: ConstraintTemplate
      metadata:
        name: k8shttpsonly
        annotations:
          description: >-
            Requires Ingress resources to be HTTPS only.
            Ingress resources must:
            - include a valid TLS configuration
            - include the `kubernetes.ioingress.allow-http` annotation, set to
              `false`.
            https:kubernetes.iodocsconceptsservices-networkingingress#tls
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
                re_match("^(extensions|networking.k8s.io)", input.review.object.apiVersion)
                ingress := input.review.object
                not https_complete(ingress)
                msg := sprintf("Ingress should be https. tls configuration and allow-http=false annotation are required for %v", [ingress.metadata.name])
              }
              https_complete(ingress) = true {
                ingress.spec["tls"]
                count(ingress.spec.tls) > 0
                ingress.metadata.annotations["kubernetes.ioingress.allow-http"] == "false"
              }
    YAML
    # Create a test constraint file
    (testpath"template-and-constraintsgator-constraint.yaml").write <<~YAML
      apiVersion: constraints.gatekeeper.shv1beta1
      kind: K8sHttpsOnly
      metadata:
        name: ingress-https-only
      spec:
        match:
          kinds:
            - apiGroups: ["extensions", "networking.k8s.io"]
              kinds: ["Ingress"]
    YAML

    assert_empty shell_output("#{bin}gator test -f gator-manifest.yaml -f template-and-constraints")

    assert_match version.to_s, shell_output("#{bin}gator --version")
  end
end