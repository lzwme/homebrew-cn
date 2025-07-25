class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/"
  url "https://ghfast.top/https://github.com/open-policy-agent/gatekeeper/archive/refs/tags/v3.20.0.tar.gz"
  sha256 "47c2371214095035a829bfda93488ada6a9cbdfe276daf04d3794c1b9569f6b7"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/gatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e0d57f904bd31e793691c6dbfe9b1a0220542c5c12ed23d5888bc392f7a1c91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66afa674e8034d5463422a6e8a0871fec0679448e7091add1edcf4483b254d5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a454fc298523a07f4d3cf3e50bbd65dc9fc7b8cb76ffe972c42a3013d409d58e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3d3100c8e5c38d715fbf17c50cfe82a4db191b202d5d6333e51a996b2a6d791"
    sha256 cellar: :any_skip_relocation, ventura:       "85d4a3a92908774f65d784d0edff20e384c0fae91b967279a4afe4a5c4cbb751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2fdf4807bbea276d62095253cbedb7ec3803acbfea434002f2ce70473d5215c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/gatekeeper/v3/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gator"

    generate_completions_from_executable(bin/"gator", "completion")
  end

  test do
    assert_match "gator is a suite of authorship tools for Gatekeeper", shell_output("#{bin}/gator -h")

    # Create a test manifest file
    (testpath/"gator-manifest.yaml").write <<~YAML
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
    YAML
    # Create a test constraint template
    (testpath/"template-and-constraints/gator-constraint-template.yaml").write <<~YAML
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
    YAML
    # Create a test constraint file
    (testpath/"template-and-constraints/gator-constraint.yaml").write <<~YAML
      apiVersion: constraints.gatekeeper.sh/v1beta1
      kind: K8sHttpsOnly
      metadata:
        name: ingress-https-only
      spec:
        match:
          kinds:
            - apiGroups: ["extensions", "networking.k8s.io"]
              kinds: ["Ingress"]
    YAML

    assert_empty shell_output("#{bin}/gator test -f gator-manifest.yaml -f template-and-constraints/")

    assert_match version.to_s, shell_output("#{bin}/gator --version")
  end
end