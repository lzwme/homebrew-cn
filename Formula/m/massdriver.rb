class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https:www.massdriver.cloud"
  url "https:github.commassdriver-cloudmassarchiverefstags1.5.16.tar.gz"
  sha256 "6170916a4a79cd1b8dcb92b69372e7e471ecf0d2d639a4982a0618f24f9eea4e"
  license "Apache-2.0"
  head "https:github.commassdriver-cloudmass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5a3391f673f9b70392c62c10e4787b0b65bb8458f12f8959ff2f08210d44ed5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f34b8ddcc1a6b38df4fa40a95e2f7663161fbebd06f11e6bb11a60650e2f3ac0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8924649ff16e77145fe80649332a5a61730457d37ff7e7df04cba18f9c7d379"
    sha256 cellar: :any_skip_relocation, sonoma:         "acab5f73414f6b24cce9540992960555a2a11181de43f21caea219438198bebf"
    sha256 cellar: :any_skip_relocation, ventura:        "e7ba42e6ee3097f7d05ee96b94850e5a80834ba2f6c928500973f968c3ecd264"
    sha256 cellar: :any_skip_relocation, monterey:       "f9b0dbbfe097636b8fbba511a721e13cf3a83f500af7d720492f052ba484de66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5afb634b8babfca1ddb2fdacfbec89bb25b7a9924f6b2a9c72a417cceb0cb0a8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commassdriver-cloudmasspkgversion.version=#{version}
      -X github.commassdriver-cloudmasspkgversion.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin"mass")
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