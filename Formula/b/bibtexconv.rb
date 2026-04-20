class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://ghfast.top/https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.2.0.tar.gz"
  sha256 "841542821ae46eaf4065e6b3b62b5e9466e4c85c17058b1b9c42f69190bd0111"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4d6ffffc224e6d13e64beb408afdec7b12d789180ae4b867a6460c50009f65f"
    sha256 cellar: :any,                 arm64_sequoia: "edfc0db60e7d5dcaed31b742538d6deb71b6e57b5039777c64eb0dd1a9b37996"
    sha256 cellar: :any,                 arm64_sonoma:  "edbe71bf6e18a179991bb5f0f8f67be142a6a8360e3cfbe10118ee91473bc8fb"
    sha256 cellar: :any,                 sonoma:        "dbc07746f58dded72794882853850bd29f4ad01c320a0b7ce9df1264a78552da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "662120d717684923235895acdc877ef5d2ddce9afaa80da1e1356eff93305ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97c2a90dc415e56946717b1413d4347b926f77fdb0095dce28cd51ca6c5ef494"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@3"].opt_lib}/#{shared_library("libcrypto")}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", testpath/"ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end