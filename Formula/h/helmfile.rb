class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "e783c93cbe8f7ab114f87fa9118b06939e63e8136c3ffdef0113c45ccbc4c74f"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cfe0162b27ff49057f5b624416971dd1a4b80ba93bc406985de64f23dcfd0ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92bc339c2eb3f34f311ac690447b9f2356b34d1b654495846de0c2cfcec261b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "255e22dd251706f1ddf47f4bcdd23178633f763df7a41624e10519843d744087"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce5ddc7406483814c53da549b57f36f2cdc743e18d60cb961a3ee75593c0b74b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c99967cf8ee5024e8de73bfc638289e7b5710eabb7917bfa753fe9e9ac0dca01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f06e49dc953bac6d43a95b12a6f1a7ccb6fbf7faf17112b1c3f47273b82feb8"
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