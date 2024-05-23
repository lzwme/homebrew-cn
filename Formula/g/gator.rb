class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https:open-policy-agent.github.iogatekeeperwebsitedocsgator"
  url "https:github.comopen-policy-agentgatekeeperarchiverefstagsv3.16.2.tar.gz"
  sha256 "e2baa5ad4d00fa3c43589a9abd4c377f2a18c40bcb46f4b4b92171da9b731ccf"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentgatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da1b3ed0a0d23e6a89d82a5f97c26d8089f294f27e24c96baf8036e296a2f30f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78270c8c501588497b1061843870139cff8befdea7bad317ac5b53f9079ab2e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7da4ba5ddc2a1d09f1f28881849320314b5ef51ef97ea4b7cf9335ed3126af11"
    sha256 cellar: :any_skip_relocation, sonoma:         "97c0f5414773f108ba2fe5fd4b11b09c65e5115de22239a91d8f7f85648c1385"
    sha256 cellar: :any_skip_relocation, ventura:        "d30aec65a4c72a7159167aacaf904105e3641c8b0a1c0436d0502fa485391af2"
    sha256 cellar: :any_skip_relocation, monterey:       "724910360fdb2858076d0c82225abcad003730bbd77ff5f857f087516cc80f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff331c159050f5841f5f7908dda9472828a35f273e7f5f47e580f94c117413d5"
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
    (testpath"gator-manifest.yaml").write <<~EOS
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
    EOS
    # Create a test constraint template
    (testpath"template-and-constraintsgator-constraint-template.yaml").write <<~EOS
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
    EOS
    # Create a test constraint file
    (testpath"template-and-constraintsgator-constraint.yaml").write <<~EOS
      apiVersion: constraints.gatekeeper.shv1beta1
      kind: K8sHttpsOnly
      metadata:
        name: ingress-https-only
      spec:
        match:
          kinds:
            - apiGroups: ["extensions", "networking.k8s.io"]
              kinds: ["Ingress"]
    EOS

    assert_empty shell_output("#{bin}gator test -f gator-manifest.yaml -f template-and-constraints")

    assert_match version.to_s, shell_output("#{bin}gator --version")
  end
end