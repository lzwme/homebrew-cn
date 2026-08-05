class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "0e6ef2a99edefb0ca2b3b3f22d08a912b2860baa7baac82978e1662cf77409ed"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b62948b39a0356ed0cad1192b0e1a4e225c202f1cbfb63ed8623d2f0d389658f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18ca5f54b4c4bb4fbd57947f5da4f688a8da477cb7ab96ef5d768d64b5094ce3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b2c7611022d2be71da542a099a291ed484776b832a7dc796c2add78f61ccb30"
    sha256 cellar: :any_skip_relocation, sonoma:        "11d6323eeaaad187753155fe1bd255e932d90b2ce79fad8ea985140d843889d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5d811ab280fabf55414532bd18b30a807f9d99bb847ebc909302cb1eb58d7da"
    sha256 cellar: :any,                 x86_64_linux:  "a161ef406bca167bdef4a3d4e0ea78c20de373b7ae8371cee3ee6d40c7a991b0"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
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