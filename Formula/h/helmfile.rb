class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "5bfb5a51b9d48b0af2b27d0dace3e5d3463587750449070f8ea3445895627dc0"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16b9e3f952e9b4678b5c2cc75151cb638bca606e78c9046eb4fd5c1aca81a5af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df5af347ce54f1980bee95bfdb266113793f95e42a6680892332f141a555b409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3b655ca781ba46355c2c17632c9adf280697dd02566388e85c3b76200d029d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4628841f3c3cb24d4f0e90ca3118817989efeb5030f24cf84a38ba92b8a19919"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb7098817263a0635b897db1598a5f4624076f52dec22133aaeba736d6c537c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "730fd4be27e9cc30fd598b2ad4a85991ac02f6a3ec6cd573a1e8cb6ea9f94d5e"
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