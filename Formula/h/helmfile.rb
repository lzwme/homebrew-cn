class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "efc1f025b33454dd7afd917aeadbe30d05a2a817d4d0242010cd69852325f349"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dec42ba4df290c57eae2d36385f3cba346d0f05e29a33ff38ff319e1ea322d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60e5b6483da78e25a59bb33fd4a3a834caa614602dd72f2b2a98aef87dcb66f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35a812144d399c8f9d23b0125b4626153f61f47830392a955d8d0f9d55ae0f03"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd99cda4b51d54f60d13ff7ead1050fe87f8bd5d15c05ae4058e9cefa9faf9d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af6447e3bca2e1533bdd763d3b02d22492fd21d5e7cf1d3f07827c88f6c4afbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a91b7d51b07cccf584682eb4f9dafd9f21e33caf452f2d662b560bccbe4911a8"
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