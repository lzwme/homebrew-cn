class Tenere < Formula
  desc "TUI interface for LLMs written in Rust"
  homepage "https:github.compythopstenere"
  url "https:github.compythopstenerearchiverefstagsv0.11.2.tar.gz"
  sha256 "865c9b041faf935545dbb9753b33a8ff09bf4bfd8917d25ca93f5dc0c0cac114"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0baa70b7b012c3d3a774dc50b20a121f4e4edbc32d3ce855196c36549ac4ce27"
    sha256 cellar: :any,                 arm64_sonoma:  "3415de2c7a37c7f05f0d445e189f10d13cf3bc0dbf4c13b7684b9899d8b76365"
    sha256 cellar: :any,                 arm64_ventura: "7c4d49ece26a9ef64424c86facc1ca2bc89b148740439d61cc2bf82386c8195c"
    sha256 cellar: :any,                 sonoma:        "dd4b840456d008367562e83e9e368d2ae8d0cfb657c596e4a3994d2dc5d41506"
    sha256 cellar: :any,                 ventura:       "ea4358924174ee2b2c85fdb2defe04c974883b9a181afc045e328eec6bb8fee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5d05813cd020da94e484be7e518d6189298b0e395707b64ef893b0ac91529b0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"
  depends_on "oniguruma"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tenere --version")
    assert_match "Can not find the openai api key", shell_output("#{bin}tenere 2>&1", 1)
  end
end