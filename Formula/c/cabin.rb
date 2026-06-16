class Cabin < Formula
  desc "Package manager and build system for C/C++"
  homepage "https://cabinpkg.com"
  url "https://ghfast.top/https://github.com/cabinpkg/cabin/archive/refs/tags/0.15.0.tar.gz"
  sha256 "9f8b4904c1d4072cddb3f8316cde694cb55791bfb817b1f5818f49f1d156ded6"
  license "Apache-2.0"
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe46469b972ffe72dd3f142f2fdc5424524fb6fa2d0178dc0cbecd4ed95d54b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "444683c0e1925aa6536bb4cf7f0dcb7010f1a0748e5e4039db58a15c08b8cdb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04bc02e370c19a3aacb92be0d3851fe99ab4e62e358e66511bf6317d4a43abd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "73aa93c00fbfea35a60584db78227bc3edb6891a76c2dc87c6197080fc09145f"
    sha256 cellar: :any,                 arm64_linux:   "d7c38baafec3462f8b01e8e545a8a52232f80ab4ae99fc8c8113022e56b86225"
    sha256 cellar: :any,                 x86_64_linux:  "cf2c61da5789eacd695739ae5364db79831af572f1dc74cf6decc01b8f9bc944"
  end

  depends_on "rust" => :build
  depends_on "ninja" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cabin")
    generate_completions_from_executable bin/"cabin", "compgen"
    system bin/"cabin", "mangen", "--output-dir", man1
  end

  test do
    system bin/"cabin", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello from Cabin", shell_output("#{bin}/cabin run").split("\n").last
    end
  end
end