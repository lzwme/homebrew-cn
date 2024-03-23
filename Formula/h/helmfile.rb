class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https:github.comhelmfilehelmfile"
  url "https:github.comhelmfilehelmfilearchiverefstagsv0.163.0.tar.gz"
  sha256 "80186d745c0e4e02b5385a0f6ed46cbc60dab2c298fc03d1937795ec10cf274e"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67cae815bc473a89b659f49dc36b57bdc192e10a9aa3dc9640a6438d0e8f1af5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd3d79ca209c426abe1903fb87d0e0492ba132d726e5fe5879bdb1a915e3a899"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c1e1eaacba3345a839978c60ace81e90531c25058ca9aa310ff7a1958558f2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c9f8444e5ad9756c462fca5c1725f508e175af40cb60409779bd65deb898db7"
    sha256 cellar: :any_skip_relocation, ventura:        "048c040b4f667e6cb29481f8456aadaa41f874f2265b8a579ea31d70659ea35d"
    sha256 cellar: :any_skip_relocation, monterey:       "b0a48adc0ed3b9529643a38fe241a75a57b3d4a1f1e4f7a55d2ca7d093e54130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b1098b2f9d27f7f75e0aef5c1d96d2eb0a80133980e676774ca4001fdcfadb"
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