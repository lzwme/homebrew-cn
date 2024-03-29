class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https:www.openpolicyagent.org"
  url "https:github.comopen-policy-agentopaarchiverefstagsv0.63.0.tar.gz"
  sha256 "0639466031325de698c61d55850c35d14a7a260ead5d5a06540ee142950818b0"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentopa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21e10e3abe9cc226a8f4c8000e01fb641f2262e1617265fc8e530e8951a8b7ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38ff4e3bc6e37c211525cb31ec3a0282ed69cf02f16f2eacc605f2e7c00f2e5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fd860d3f8c318ec4f5ac0350505e52bec4c247525fe7aa01d9dc4721b40b18d"
    sha256 cellar: :any_skip_relocation, sonoma:         "97e72c3ae35d24410a8939a658ded791f558cd8481d8fdbd52b2888b7bda510a"
    sha256 cellar: :any_skip_relocation, ventura:        "2ee1bb2d3c4067ace01ac2e26e837e83af016d47d67df6af01391909056f52a4"
    sha256 cellar: :any_skip_relocation, monterey:       "9e2543b06e74e38552e3f28fb9afb4a0e90e014f0ac58c09d9e581a5dd7d973c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9ce5a70652dd25b377c0864af194d41f2ca57db9370455b697c1f1ede86cf89"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopen-policy-agentopaversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system ".buildgen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin"opa", "completion")
  end

  test do
    output = shell_output("#{bin}opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}opa version 2>&1")
  end
end