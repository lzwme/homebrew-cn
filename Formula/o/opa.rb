class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https:www.openpolicyagent.org"
  url "https:github.comopen-policy-agentopaarchiverefstagsv0.64.0.tar.gz"
  sha256 "93fa1e04278fb2aadaad3fe2a58e64c152f615ca79705219ffb774d715d58f97"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentopa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed34c9776769b1d32640ca2a014790b7b90e027c1beac3b70135c3d59831b3ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2fc030e83c7e354708354a824d021353a683e40a423c27c2adb580d257c6ae8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94cb110d5607c512653a2cc65a7216c71a284bd37bb0fdf82fd1228c25efd80b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d23ba010f98300cfad7df661e8abc45b00a9251f2109361d2d2b558f4baf422"
    sha256 cellar: :any_skip_relocation, ventura:        "820c5247d964cea5fd0d9432b34e6f6f8c7c40dc725d1399042b3c343e56322b"
    sha256 cellar: :any_skip_relocation, monterey:       "4d2f9c607b307d5c82b3f125fe37035aa6874227af0e63e4bd46795adcd086db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39bf4d190e56b6d047b6385a6247965c60ae442b7fb80ca8266e261f1879467d"
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