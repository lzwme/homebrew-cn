class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "4db4e52d34899770769836352b1046d3e2c4d1c566ac4372879081199aeb2dc6"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cc74ba671d3a95d4cbbb0ecb94ef1ef364168885cc2e79384558a8d6505708e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "226cb23d7284a45aa4bdb45966c6813508d064388456d2b0893f510a940f85ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b7b2d60652f26050349dbe86d248ed485e7f97eca22f67281adf83f101306c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f33c29578c3477102eed4f4a42fdbed9b5ebd2ce4b944e1fce2e70718b2cdabf"
    sha256 cellar: :any,                 x86_64_linux:      "63114c255057fdacba17cbce26582364c7a597f837904f8d77ea282937acc17e"
  end

  depends_on "go" => :build
  depends_on "helm"

  # `test do` block adds a helm chart repository
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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