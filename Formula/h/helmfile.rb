class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://ghfast.top/https://github.com/helmfile/helmfile/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "b167615fbded69cba49202ef65b02dd7d6d0814534aeecadfd68be39bf267618"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f6093c36e72208f1cb1131808bf20fb309282e8b021a224a3b02d48077fae0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "549ddc247a62f515429102d9e81c6c75611fb048439dbcacb7be6c571aaab699"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6850fdcfff8c80a769c0d5eb37f9f8ab5fde8a8c0fe0be25c5f5d7e17ffe02c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d2e717724db7584f7a720aecb8aaef4bce309b30577cae4b537daf08d2b090c"
    sha256 cellar: :any_skip_relocation, ventura:       "7639a0451fed88f2b3a1b2311a871f5a245b848b8e7b9b0b14c03c8b5612698a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9185e5ca20b9fb289f7fd0107dc6fe7ae432d4f0f119848843e10091218d09f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d36fcad02eeec99addcc59c94780400e93d8d7874e1486f8f635784c1d0e4f97"
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