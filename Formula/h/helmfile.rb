class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "bb3d9b36a5eaa25fe95ab25a9f2801a73a0f6ff389ed8192929056affc0f1d46"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a692352227aedb0324f186c52621f5105fc50b1958d528efe0e23671a49ef3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "846cc23c49c5e36867e879d30345ae13f960945f06ade82e5fdc33e626e25008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "236266604959327dd86d532ba1962f157e5eb6bf948927080a71e517f68ad633"
    sha256 cellar: :any_skip_relocation, sonoma:        "cddab85b3abe173ae667dc3687852e967f1db99a53ea45b26b4546c3985b4dbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84898cb751cdb430610a147ee129cba2ab0fb987650e7e992a879b94dabff448"
    sha256 cellar: :any,                 x86_64_linux:  "0106ba70ad7037a5c8fbc38749ecc4c9b09f23fb3db30aeec23e81ca5ddc6e91"
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