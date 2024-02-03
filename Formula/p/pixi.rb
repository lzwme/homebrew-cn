class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.13.0.tar.gz"
  sha256 "7b4416899be4a308cdb55db6665c20870d7a3c614c4f99aa79fb91af282fcd32"
  license "BSD-3-Clause"
  head "https:github.comprefix-devpixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da7c524e6ef11f40635cc58e36897675dfc29dec89467d6b4990d87b44f69373"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fa643ac0302ba7e78b582f6cb36fc97b832917bad42d5d8ed464003528d9476"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34e794ecf14c0ef96a8f083926e3b25f18a380d02aaf43ba5e0cbe92f6e4ec3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "01b5327e2411c90bcea03a9813b4c7a808dbc5f1adfb98e0c6d06dfca17f1677"
    sha256 cellar: :any_skip_relocation, ventura:        "b65dd6de2ec2ad5eceb1bbbacc600dc218df28669d52dbe16f5753a21b4f6906"
    sha256 cellar: :any_skip_relocation, monterey:       "b9d182becb5b044a222ddef1a9a73279d1de81092f18fca1666c28e17452a6f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a0b904eb1a7236f0fd74b858e183f8d99415c0c257238bb465e505ef1cd8594"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}pixi --version").strip
    system "#{bin}pixi", "init"
    assert_path_exists testpath"pixi.toml"
  end
end