class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghproxy.com/https://github.com/helmfile/helmfile/archive/refs/tags/v0.159.0.tar.gz"
  sha256 "56a9c510cd5832373468623b2897948b679e09ad090b9e41991b11fecd553360"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd599732394ad35fecca11beb61b7f7db40b226d84846c90eb7240d2387b9b2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1802fd3d09cc122ae47783f5e500e4d2da738dceb7c16babcc776779dc987769"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c5a0e2a6c72787103e8c62024c65abfa75b823de8d578664ccbfa0affb0d217"
    sha256 cellar: :any_skip_relocation, sonoma:         "080aa2315857affcdb61fa3f2c506b139c9b80fb082cb5e30e0aba430f074772"
    sha256 cellar: :any_skip_relocation, ventura:        "e6b8178f50e3ecadfefa63dbc398b5b24dba826febefcf4e6dbdd9e1eb2f1141"
    sha256 cellar: :any_skip_relocation, monterey:       "56027f12e328b2e153b5251b7927cdf09036568d4addf0c293527cddcf03b41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecc6ed737a3d9142432c492d884b53afcbc20130e1549edfd60efcc1d5a7d2f9"
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
    (testpath/"helmfile.yaml").write <<~EOS
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
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end