class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "428289656d571a20982dca8f254e1450af1849a86a736492c4b21c3857b83e43"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90a4e606bd85998d832ec546947ae1a890babe09333222f9585561e051659c5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50199b35f67896daae60b431f57e918a83e9c47acf5909e9ad6f6e714f4f5fad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc197ecf2ed9e15b6399baa013d959f83866602e66f4ad82b6a422d3bd3466e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a144a34fea2e31711cd20665d268d6dfeab2402c36d1f973bae3e34f2480360a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b75962ca4d4196868b8de7bb59fb9e036be7178bc58f5fae90b14fa297916e46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771d5ba595720c0ad6c72815e26b7006c46cddf37d139abc72bece4760a061c9"
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