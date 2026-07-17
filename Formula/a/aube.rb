class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "aff11d67c74a33e8f62643f66d648048953b35a5e894ca43d63f398b58523f2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cac5104636819cf07dfb6e222eb40c1c30a08bd0e5d5f22cfe35c8abc64f6077"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0ab3ff9746a7061be948733e6616cdab453dfa466fe0a92fcdb47446538ae2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83fd8cfaf0b9dbf1d950acf9e36b71753ad182daab475ad0e867bef0dc792495"
    sha256 cellar: :any_skip_relocation, sonoma:        "344879677e63acd08fc174106690671b2be0d5adc1870a9c7c9513cd8f205d05"
    sha256 cellar: :any,                 arm64_linux:   "6e27e6e67192af09fb4ff27f1716b061f298de57c6e4360cbd41370344cd90e6"
    sha256 cellar: :any,                 x86_64_linux:  "529ead284849e98f8f8e7ac3d90a14e70dd201ac6915d0de9557cbdb7d24b3a4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end