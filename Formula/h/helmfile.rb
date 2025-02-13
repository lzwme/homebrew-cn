class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https:github.comhelmfilehelmfile"
  url "https:github.comhelmfilehelmfilearchiverefstagsv0.171.0.tar.gz"
  sha256 "593c51bc5b4e422d347706e1785f3ac2044b437369703907fb120b6ca23d333d"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78c1d4d01dcfaae0cd5f9d6324922da312e14623270520959788292e192f2b2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6fb2e57abe14764b23866e4012c82a9781c920d9b51b349bdb37ce955ebc38d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10b2116c716d5fd68957b5a0e9cac2d957e9f84c9f4d78afe3d4c471a99c738b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7faa9da84db654cecb2a978ba2069df19b8002013946df856702774f9045b916"
    sha256 cellar: :any_skip_relocation, ventura:       "95e2ced83d0922f2d5a1065c0b6a16604d97bf79a60cdfe97b430899efb83f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e77aa31ae7642b0f2c7934ba34ff09f66f8c70d795cde7cea1307fa421550c5"
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
    (testpath"helmfile.yaml").write <<~YAML
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
    YAML
    system Formula["helm"].opt_bin"helm", "create", "foo"
    output = "Adding repo stable https:charts.helm.shstable"
    assert_match output, shell_output("#{bin}helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}helmfile -v")
  end
end