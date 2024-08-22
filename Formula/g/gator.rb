class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https:open-policy-agent.github.iogatekeeperwebsitedocsgator"
  url "https:github.comopen-policy-agentgatekeeperarchiverefstagsv3.17.0.tar.gz"
  sha256 "21393d26eda2d07366bac5cfc6f1a0eebec140ec36003ab766536f029c751968"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentgatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b7d3e6be06c133db52be65967c94e83fa4964404dc64ae0e8f98d973e4beede"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b7d3e6be06c133db52be65967c94e83fa4964404dc64ae0e8f98d973e4beede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b7d3e6be06c133db52be65967c94e83fa4964404dc64ae0e8f98d973e4beede"
    sha256 cellar: :any_skip_relocation, sonoma:         "5239077c96d5e3be2ee98d62eb97d719f28b8bcebf28b3c6e46e26cf7cb7e99d"
    sha256 cellar: :any_skip_relocation, ventura:        "5239077c96d5e3be2ee98d62eb97d719f28b8bcebf28b3c6e46e26cf7cb7e99d"
    sha256 cellar: :any_skip_relocation, monterey:       "5239077c96d5e3be2ee98d62eb97d719f28b8bcebf28b3c6e46e26cf7cb7e99d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef854c02c09cace7a8d50466b3235002d462ad03352a7d4ae462bea906c97d40"
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