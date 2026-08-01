class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "44b147676d77f193d5dc8182ce9056cf313186947a866e7f76a8badeddd9e9be"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40ad80802a2312652119e36a18ce377e16b3d04080afc508d3b8b29ab2ae7d6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6deecf15b20c09a2502d5dcfb7aa92618ef5110a9ef90bf5549dd90b7f5120e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "666eb3013bd79c7ac7decfc29aa08c05835a33bdd4fb67bca72bdcf647e64d5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc13ed0722ef9e8230d7a2395b49b39857a0a5d193e889009d644f51f2e5c98c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1467ad4e936fb104b8b6f29c35c63d3ff2b715b7a5314de3e56f0b3587fe5eaf"
    sha256 cellar: :any,                 x86_64_linux:  "a844e8940665ce3dac3a05f443dda1029d088b292eace47fb8f39a2f151df7d0"
  end

  depends_on "go" => :build
  depends_on "helm"

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