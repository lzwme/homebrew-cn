class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "95113afb7ae65ad7f2ac026288d6ca23d344420ab942983a9456c2b8d6876302"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ccab9d90f777fe536b4437d65e9e89e9eaba989b59b5bd9dd135d365b5fdd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "797c1a99c9c0778c3621b4892f9731c7293d3fb17f65055a489d9704aa358b51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bf7d54d0a1f0cbe1ea8bb802a05fb0e59061ca84e1e07d9afa4128b956dd4aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f9ace1f5793819c63d57e5f6b77caaf1fd16f527c1ffd3c150aa0d7149c7b68"
    sha256 cellar: :any_skip_relocation, ventura:       "d3ffe00d40b27558c75e6ae6d2780d137ca5aaf6614776f399f45ae55912eed9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a06ee0a5cb36823c7f6561dc2fa15327dea68d6492882efc745ae901325d91c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b0082c5d67d6d8d1875f1ef7f586f565afd586f2adeb5c7c6744f083b45f9b6"
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