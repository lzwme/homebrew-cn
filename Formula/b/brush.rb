class Brush < Formula
  desc "Bourne RUsty SHell (command interpreter)"
  homepage "https://github.com/reubeno/brush"
  url "https://ghfast.top/https://github.com/reubeno/brush/archive/refs/tags/brush-shell-v0.2.21.tar.gz"
  sha256 "8604f4d5feb28a3466687f491d6bbad9d9e19c258e3c8c8d68209da5266b67cd"
  license "MIT"
  head "https://github.com/reubeno/brush.git", branch: "main"

  livecheck do
    url :stable
    regex(/brush-shell[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71a5d3f4313dbb284884cb1d0d3ac97d361e7a1b21611c998b401a621ddd1ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37e2b9b3214e79cae2c486e2ed44fcb9510fc76149259d468a55ed4782f02867"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f971f59e3ba576367c1b5a7d8c6071af532471f5999ea627ce5850e2cc4be04e"
    sha256 cellar: :any_skip_relocation, sonoma:        "74e43d50ce87a03d845ca613a5a52430e9d2954ea34d736f4e6545ce9fab54cf"
    sha256 cellar: :any_skip_relocation, ventura:       "7deb324d5931e2b350531e3dc54de37d582a4a44827ed2125902c8ccc78cdf7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ed7c082d3c6c55e95b2a72ebb96e16e2142cfe89e9da0e6067b2f627c021eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e83c40424acee87c2a41fe5abb2433bf9aa48227e3ed6a2b66bf3473c3ed0360"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "brush-shell")
  end

  test do
    assert_match "brush", shell_output("#{bin}/brush --version")
    assert_equal "homebrew", shell_output("#{bin}/brush -c 'echo homebrew'").chomp
  end
end