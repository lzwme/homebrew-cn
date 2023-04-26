class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghproxy.com/https://github.com/helmfile/helmfile/archive/v0.153.1.tar.gz"
  sha256 "44517acd96898c18b617e0c3b0b8fca8ba4297b04e50d5636ca29d1ad5fbad65"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "223e7d04b3001d1b0a2275bce2154d29e8d3e808339e1dd5c4c725d17c1062e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21737f4e33ae12b48f553ec38ae9b8d0841c2fd88d314647d66192f70afcf96f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0076fd1732b3e872ee11f6b6e304a78b042e0c3497cfd9579b152375c138930d"
    sha256 cellar: :any_skip_relocation, ventura:        "76940f8f2020763963cb8027b71ffbd517c8ae4da712a4ce00fbfec509316109"
    sha256 cellar: :any_skip_relocation, monterey:       "9258285dd15c79aa7dcc73ce261870fa172bc529b0cc43f731a164290ceb0911"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1141abebc2c64f34154beb42f6689e6a6c4a5ca41c5da919c2c0370e9f988a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8219c4f15ebc9806a50831302439d1b78f12be556b09b2c6565159e86c72506b"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"helmfile", "completion")
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://charts.helm.sh/stable

    releases:
    - name: vault                            # name of this release
      namespace: vault                       # target namespace
      createNamespace: true                  # helm 3.2+ automatically create release namespace (default true)
      labels:                                # Arbitrary key value pairs for filtering releases
        foo: bar
      chart: stable/vault                    # the chart being installed to create this release, referenced by `repository/chart` syntax
      version: ~1.24.1                       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end