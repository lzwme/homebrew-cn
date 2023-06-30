class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghproxy.com/https://github.com/helmfile/helmfile/archive/v0.155.0.tar.gz"
  sha256 "4bcb0b7d051c8d9bf91c0c3c6420c18ceb8556190a31451f64555acbd769a7c1"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5c96eebacae7ab040f6948aefef1415d621fe55324e7160376273546005b68f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf39078c134d6cb752fdd67c716e6162035904c6ad14f2b1f0c237287791eec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "051f307dbfd7c47719209aabfbd474d499c11a4aed991c49f28ec6b6bca0b894"
    sha256 cellar: :any_skip_relocation, ventura:        "9274aff38ff550728c2c8a3853e86835aa341352ecac9d85e53b93f89125a1e6"
    sha256 cellar: :any_skip_relocation, monterey:       "c83d776fe725d0e03b0d2e6a57f79d7951f7e9457e22a99b38da48da0cfa531d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d152cef165ac21b2b5acdf2e445f0c33e670a10806153f8d0b1492439287066c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01876a017714b41f048492cc160dd24af330b001c46d1bb3407443cca30ca758"
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