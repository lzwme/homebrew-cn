class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "da8162000e9cdf7a8c95d5191f3779df8b065ef5c722f292e77f6e8f77a7864e"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb8324758af1e5bd73eed9ab0866c111984e936cbe7d1170c258988f74e7ea5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754eaec3c83d7562f058a06714cfd2934cce404b7f329851af5f77dce86d8e2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b35b4be08213782ec8d3121f0758eb084feb540127bcb5d5e4d46618c6df7a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5742919bb2ffd2e206322ca40b87547864bc92ccd9f10e319bad6b7aef55ed62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e8b8aa55eb734d81f5404ebbdd6b05c29b8ab39f939e37e4c910d422047eb1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c7107ece93aaf96dec6f45a83f40e410cc0ccffade6eed4a90a0b032e012633"
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

    generate_completions_from_executable(bin/"helmfile", "completion")
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