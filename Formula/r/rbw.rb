class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https:github.comdoyrbw"
  url "https:github.comdoyrbwarchiverefstags1.11.1.tar.gz"
  sha256 "8fa68b1bda014fdcf087640aaae5db100e2f51f800d8fbac37236ef4e374ba74"
  license "MIT"
  head "https:github.comdoyrbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b5f7c0a039b4b6750d442aafea765409ab1e7232943fd788d1ef2231d763f04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1e328bc5b582b8393d1e815f0c677118cecc2e652193bbfe23983a23a6f7939"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52995c0c9c4a44718c490ad39b686c7255cc1f7ec3cba03d3ec06f54481d0ea8"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb8c5fdfcdb48ebefbfee2510b0978027bd1726366042ce02112b7be5fe0315c"
    sha256 cellar: :any_skip_relocation, ventura:        "d94e73a56a724f3b78e55c8651039a15c588324a6d03991b3c5128a54120465a"
    sha256 cellar: :any_skip_relocation, monterey:       "206fd0a432a5d934f890f5be1ce7973aef5dac5d6e607e73400f97e457ce47bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c680e2143b40de0271b291852aa9c409b70242bfe498324a4a5f217092ee693c"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}rbw ls 2>&1 > devnull", 1).each_line.first.strip
    assert_match expected, output
  end
end