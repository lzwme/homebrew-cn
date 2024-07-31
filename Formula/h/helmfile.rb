class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https:github.comhelmfilehelmfile"
  url "https:github.comhelmfilehelmfilearchiverefstagsv0.167.0.tar.gz"
  sha256 "0ca8959488a1f48e596277deba7baefd36ff8c43ae53004125cc0c33e0ea3f3e"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33548cae1f3f079257ee9fecfc501e3a174c50ff185beb2283a89e32cfa2a9eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "282312be8833b512e0de0fb8c60739dd760ad1be645ad2482d3db6e2c8008566"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e228fbfafdee1b4f700af6dd85416b53922767698d77394b53df9ce7ad1ec27"
    sha256 cellar: :any_skip_relocation, sonoma:         "af06251330996ebbeaa905376940db87c1fa0401644cbb90432e9801334c2216"
    sha256 cellar: :any_skip_relocation, ventura:        "20d62ace818f209b5a2a3640f9ba0cde865f2c683521d890e65b6e63991754e8"
    sha256 cellar: :any_skip_relocation, monterey:       "40c1d3845a7e72ba4a6d06c55d44985bf6fddb0d0c6ea5843b54d634d47a2b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c275f00d74122cca7011572d0a37a11b6b126166c23c8c4b84e610b386f8483"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
      -s -w
      -X go.szostok.ioversion.version=v#{version}
      -X go.szostok.ioversion.buildDate=#{time.iso8601}
      -X go.szostok.ioversion.commit="brew"
      -X go.szostok.ioversion.commitDate=#{time.iso8601}
      -X go.szostok.ioversion.dirtyBuild=false
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"helmfile", "completion")
  end

  test do
    (testpath"helmfile.yaml").write <<~EOS
      repositories:
      - name: stable
        url: https:charts.helm.shstable

      releases:
      - name: vault            # name of this release
        namespace: vault       # target namespace
        createNamespace: true  # helm 3.2+ automatically create release namespace (default true)
        labels:                # Arbitrary key value pairs for filtering releases
          foo: bar
        chart: stablevault    # the chart being installed to create this release, referenced by `repositorychart` syntax
        version: ~1.24.1       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin"helm", "create", "foo"
    output = "Adding repo stable https:charts.helm.shstable"
    assert_match output, shell_output("#{bin}helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}helmfile -v")
  end
end