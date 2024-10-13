class Keystone < Formula
  desc "Assembler framework: Core + bindings"
  homepage "https:www.keystone-engine.org"
  url "https:github.comkeystone-enginekeystonearchiverefstags0.9.2.tar.gz"
  sha256 "c9b3a343ed3e05ee168d29daf89820aff9effb2c74c6803c2d9e21d55b5b7c24"
  license "GPL-2.0-only"
  head "https:github.comkeystone-enginekeystone.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ccd260480e31343df08f282b31c71ba54088029cccf2e210afd58ef404a64be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26489f253fff8ad2046ff3c2faf2f8a7d2601a2daddbe512944deb882a17402b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1b296425709c379e4ba6e27054a06aafa876b1fea1f4a5e8d72ff131faf2e86"
    sha256 cellar: :any_skip_relocation, sonoma:        "51d036d346993a190ad6e348e4188590bd9c953a440d4dcf2e044e2e3c700ebd"
    sha256 cellar: :any_skip_relocation, ventura:       "eba0bcccc49e5776fe9e53cdf27c2577c150ff5628d6596da02d8dd1d95f3b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc74b3742a7af0e95d1bda251428ebd57ff0bb6062fca7ca14d54c4ea92a176"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => :build

  def python
    which("python3.13")
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXECUTABLE=#{python}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "nop = [ 90 ]", shell_output("#{bin}kstool x16 nop").strip
  end
end