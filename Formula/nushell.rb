class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghproxy.com/https://github.com/nushell/nushell/archive/0.80.0.tar.gz"
  sha256 "6331fe7abeee87b7188639c0ed18ebdb288f188a6de1d12b9f4f046f595cf8ce"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "11ea1d5f36a9d9de2d1f6268f07b1f2371b0cf0cddbe549558e7245f6018ff7a"
    sha256 cellar: :any,                 arm64_monterey: "46264be576ce674479d8d03025ee58866f9352c65b647d188b06d1e8cd67401d"
    sha256 cellar: :any,                 arm64_big_sur:  "eba980c9a5f2c4d1770bdeba5484df0ef5caffc95bd0d58fdf64d1e03672e383"
    sha256 cellar: :any,                 ventura:        "1f2f7cca70277aeb56e0da67e766808664f3289bf5de1b6873192cf5152ab1ba"
    sha256 cellar: :any,                 monterey:       "54cd3f7212cf4897286a1f5629ad75fe0aeb4e39c0ce2fb246c109b8cf5b4ffd"
    sha256 cellar: :any,                 big_sur:        "234b5dc66106af94fef8acc0ac81609a5779b21c59caf23614202ebf2c150219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aceb2c4faeba6664a7f7bf092aaba156a52d9c69b6444e46956baa841eb4124b"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "dataframe", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end