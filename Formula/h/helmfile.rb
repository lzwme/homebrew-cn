class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "dc400c139a506281387c0628c5fdcaf03f96c144427258555c57638412944d98"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9de6ed5410fb4e0051c8c40b695e8ec64a77cd121bd007cef648f525eea6b2e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "503d6b289cb2b28e6e966e901ef1061dad883b78332b26c1dfc20735cb140e15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18e3a4520b7b070f4f318a0f39842beb6d441e707fa0fb110fc3b91dbd94b0b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c1449b3a5596fe58fecaf4d7884a2bfa58eede0b990425b58602de122755712"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "211d34b17dc812f3c52ec98ba13bb016d4cf0cf3858393549159323b9981c344"
    sha256 cellar: :any,                 x86_64_linux:  "ce08cf89e0d09ff073e343b0d834f47e950b946faabd98025b858803984f4799"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
      -s -w
      -X go.szostok.io/version.version=v#{version}
      -X go.szostok.io/version.buildDate=#{time.iso8601}
      -X go.szostok.io/version.commit="brew"
      -X go.szostok.io/version.commitDate=#{time.iso8601}
      -X go.szostok.io/version.dirtyBuild=false
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"helmfile", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"helmfile.yaml").write <<~YAML
      repositories:
      - name: stable
        url: https://charts.helm.sh/stable

      releases:
      - name: vault            # name of this release
        namespace: vault       # target namespace
        createNamespace: true  # helm 3.2+ automatically create release namespace (default true)
        labels:                # Arbitrary key value pairs for filtering releases
          foo: bar
        chart: stable/vault    # the chart being installed to create this release, referenced by `repository/chart` syntax
        version: ~1.24.1       # the semver of the chart. range constraint is supported
    YAML
    system "helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end