class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https:open-policy-agent.github.iogatekeeperwebsitedocsgator"
  url "https:github.comopen-policy-agentgatekeeperarchiverefstagsv3.18.0.tar.gz"
  sha256 "4564db43bf46d6427ecaa3ecd4c3ecc6d7826e36c7550a48e17e0849fe26c901"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentgatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2aa2350ffbfa52e325b127ac350162ebcc0f9779d5c618e2caf89c3ba06cdd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2aa2350ffbfa52e325b127ac350162ebcc0f9779d5c618e2caf89c3ba06cdd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2aa2350ffbfa52e325b127ac350162ebcc0f9779d5c618e2caf89c3ba06cdd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "37e1fa82f1580421c24919c12417e0941e5aa097cb1b2c0f0388606bd1f6da2e"
    sha256 cellar: :any_skip_relocation, ventura:       "37e1fa82f1580421c24919c12417e0941e5aa097cb1b2c0f0388606bd1f6da2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43a334b16222ae9b80de31197be6bb79617a6a1492788ae39620b603322622c1"
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