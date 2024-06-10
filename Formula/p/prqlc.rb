class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https:prql-lang.org"
  url "https:github.comPRQLprqlarchiverefstags0.12.1.tar.gz"
  sha256 "a7890e453db17d7a028cc48dcce5378d7e86a5c3645bfe7e00d70d944ba5af71"
  license "Apache-2.0"
  head "https:github.comprqlprql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94f42b77bb658de2cf7c29897e8fda77d2cfd8b51ec077ab0f891425f953b8f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0204968e8cb94c88f07b31feb92f4315b7323af54e0180cd21162a6f2a6c46e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "105c8248f12c8e6ad585cb616b14928e32fcfd52edffade006998c6997d92f99"
    sha256 cellar: :any_skip_relocation, sonoma:         "24c69406de63c31cac94120406cc4bbf8499c5753b79c9bfc5119f5a23655c0d"
    sha256 cellar: :any_skip_relocation, ventura:        "1030db0fc54495a871ed001a98b1eb8919ec8ca748839e5ad6a9d4d11f56f919"
    sha256 cellar: :any_skip_relocation, monterey:       "2250a82751ad07664f5dab52ad206f18c77dc2591bf0249a66ca69bae16dc4f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1031553891a77e32adec3cc871373e2585f63459390d0aea684137c0a624caa6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlcprqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end