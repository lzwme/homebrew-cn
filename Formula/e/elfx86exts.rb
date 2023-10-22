class Elfx86exts < Formula
  desc "Decodes x86 binaries (ELF and Mach-O) and prints out ISA extensions in use"
  homepage "https://github.com/pkgw/elfx86exts"
  url "https://ghproxy.com/https://github.com/pkgw/elfx86exts/archive/refs/tags/elfx86exts@0.6.1.tar.gz"
  sha256 "64b218bbddabd1484ecb092f4e55a7fc6095b18e76170cff2d391822c91b7ce9"
  license "MIT"
  head "https://github.com/pkgw/elfx86exts.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:elfx86exts@)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73b494a5b906d4dd12879622dd51f8b5b781c4d45ba59991eaeabf1b0b247d80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dcd1d75a9e8f897faa804e16bf979c5fcee55e5f56c1d3006794f0c5d551d8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c657b8e8829c4637ce4df5d33e24d2a7a1d6c0211250989ca80f4a9b1d644db"
    sha256 cellar: :any_skip_relocation, sonoma:         "69c8b6bbd323fd4687a86940f8a134994a0e2138619b9b093d9e4e24d50b7203"
    sha256 cellar: :any_skip_relocation, ventura:        "4aa7430eec235cb5f83d1448c2a2b8dd831da214ed3282289408f53ab7ba62e5"
    sha256 cellar: :any_skip_relocation, monterey:       "7327c27537ac203c900d266f0f2f89f910de5640753b0b59137ff3376c808917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "893c4936e95086dab4b7da3455a6ebf4a1c8ede630858a3a329548d5ecb851d5"
  end

  depends_on "rust" => :build
  depends_on "capstone"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = <<~EOS
      File format and CPU architecture: Elf, X86_64
      MODE64 (call)
      Instruction set extensions used: MODE64
      CPU Generation: Intel Core
    EOS
    actual = shell_output("#{bin}/elfx86exts #{test_fixtures("elf/hello")}")
    assert_equal expected, actual
  end
end