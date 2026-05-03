class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "4789ebefb01a525339296c5dfa988467eb294dfe2ec1a8d78c13b18bb55a80be"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "104a4e1427e9ca45faad549f0c1004d57c66bbca06fa38fc20b5978096f38f6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a78a6d29b0185ceabd070d04b4ed5fe11b4b6794c62e8cf31e8d6a6e54a1a9d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0507974af138c6c3ca0b1739e0340c8ba0132c935237285b9931d502af207629"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc4bfad09a25be9817ad1828b9da5064f33b8528a9063db1892e6472470ad9c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3dbe79f6a9e960104a33c6e63490f1854748570a4c204a6cb6722f0c793cbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e5f3e03c83e6f3eee2568b61ac50d2346a355d2dd1e52a44c0946345d54e3b"
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