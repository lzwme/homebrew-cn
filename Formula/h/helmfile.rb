class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "3a7851c5df3c10c3d99ed416876015c48ea6ee1cd7b7c8c8d2f75939b50c66c0"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77b8e68a59510a1854578f5d22c02196e652639531fb0dcd675ad8603728597a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f43a160111654c9ab49e60f07369e0e0cde66c6712f175236f31d334182322"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "babf48d0f9bfda3c82f1527d899bdaea31bce048db67c8eca41240474d8d29f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c6f10a527ee9091bcfdfea23542c2b3354dd8cc6ae521253bb570b8d2ec704e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc5f478aaa12da029fb5a98d73bb0bc59003c240995b8e9d95acf0822b447f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37c2034d9ca5d533db7104e2345d4d6270cde341aa3b4aa058e0195165abf5d4"
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