class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https:github.comaandrew-metgpt"
  url "https:github.comaandrew-metgptarchiverefstagsv2.9.1.tar.gz"
  sha256 "05c2d2009789679fe1d744474783a853abc79d3dad6d14871402ee933397fe00"
  license "GPL-3.0-only"
  head "https:github.comaandrew-metgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1d9b62dbe8a16a44d4ed5dc39b05f1c5fa2e272ad019105ab0b6f2073d0fb06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1d9b62dbe8a16a44d4ed5dc39b05f1c5fa2e272ad019105ab0b6f2073d0fb06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1d9b62dbe8a16a44d4ed5dc39b05f1c5fa2e272ad019105ab0b6f2073d0fb06"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc1e4fd268f8cc1956e6205ac0b7279277c4fae6c99e3e4d36b2af62067c0506"
    sha256 cellar: :any_skip_relocation, ventura:       "fc1e4fd268f8cc1956e6205ac0b7279277c4fae6c99e3e4d36b2af62067c0506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab8339a7869e2770fde0ca817c85231dc0878fbef00968eb334222f934550be"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tgpt --version")

    output = shell_output("#{bin}tgpt --provider duckduckgo \"What is 1+1\"")
    assert_match "1 + 1 equals 2.", output
  end
end