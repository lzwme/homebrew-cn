class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https:github.comhelmfilehelmfile"
  url "https:github.comhelmfilehelmfilearchiverefstagsv0.166.0.tar.gz"
  sha256 "d23ef138db8b1fcea4737fb67c52b45d34676aaaf25dcce3449e20079734dfbe"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69a4a4fa038825983cbb6c449453cdd4097d8be706bfeaf8bb2c38fb8f8f14bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a37657b6714e86b14d127664e2fa922832288a06aff45d157acf3c37d45e77c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77fdfc1949fe41dde68c546c62acca45c973fc28167df39890a184c6ac057e11"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5fc56edcfb92b329cf33ca4dad6ad69b3c5c0f97b55c1e650e21dec15d77521"
    sha256 cellar: :any_skip_relocation, ventura:        "3fba61471d9242660d2dae6b62083955b333761588fdc2a00891ab61ba3d83e2"
    sha256 cellar: :any_skip_relocation, monterey:       "1b809edd5e825297d1a37cd964c50b089ff03d8e52c776333c69e5fc1c239292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d884e6d6042dc85bbbb79339c482c72fbf349abb516d6a363392ca991798901"
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