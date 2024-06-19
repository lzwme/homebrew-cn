class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https:www.massdriver.cloud"
  url "https:github.commassdriver-cloudmassarchiverefstags1.8.0.tar.gz"
  sha256 "23dfc707aa51308c06074a316bac7cc6e4102a2083d20752995db5c6147296f1"
  license "Apache-2.0"
  head "https:github.commassdriver-cloudmass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79d292628c745b7351c77fe267b12319493d3e4c4a8405a89f208b41a3d457bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "131de6b276d70002993dbb1820c8f973d869b616cd1501ae1c24631f33440ee6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8db7faf5445daa44177857a4cb218ed9a4e2f7223e8b9698d2bf72ff957694e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4ccd9346e769cf1023364d6def62a00f02d2b4022b18e29c36bc45ac6f9a271"
    sha256 cellar: :any_skip_relocation, ventura:        "ef2cbeb118cc4921b2c806a189671d3d3f2f2bcc2575abc5c165c80f13308101"
    sha256 cellar: :any_skip_relocation, monterey:       "80d2fa1f6c8cf4c1c9c2252015c13d44a46cddca1ca3bd7ae67589607a1c6dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0277e29418a477a38b9c6c4d1adc2475539470a3bcfdeacc8b4dde718f6f368c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commassdriver-cloudmasspkgversion.version=#{version}
      -X github.commassdriver-cloudmasspkgversion.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"mass")
    generate_completions_from_executable(bin"mass", "completion")
  end

  test do
    output = shell_output("#{bin}mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}mass version")
  end
end