class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "1a526686dd84bd927a85ea8b2848ff36b3cec9d387f50883d9e26613ae5b998b"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28567c881f9776a0fb023657870140e2c5ce0d59bee2e700f5ec5c1c0e11123e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03b2d17c01a82ef7295f601984921cbe8abaafca7235de28862ae87da281611b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a88b119a35ca83bbb9140ec9d6ca2daf35283a5f3559385eed4086264dc343d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c04ab4cc03eedf83407df9e909582393048693774f0d1e147c90674338fce497"
    sha256 cellar: :any_skip_relocation, ventura:       "45add77843d4d6ac3b2199ceaf877a5bc7bdcd8706091d044c65880815a2bda3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e83229d2a92de02c013e75534c46b7cfa305a14d784e27e59d6b7f27a98e3f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "821d553892a058506783705a60ab3a7eff0e9b6efab72a2dd423d390da9a307d"
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
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end