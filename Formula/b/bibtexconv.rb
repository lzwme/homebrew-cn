class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.nntb.no/~dreibh/bibtexconv/"
  url "https://ghfast.top/https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.2.5.tar.gz"
  sha256 "5d766ec9af261288a71af9d389b407ebdf3a5f5739a166be86e355f2304c7843"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8c8838a0208d2ca94232f6a6b2ba99217740eb07752544f52d371965ef48dcff"
    sha256 cellar: :any, arm64_tahoe:       "a6b8fdb3a90cbb0c468ed72192e3d89fced096c6003aff96f2330b70443799f2"
    sha256 cellar: :any, arm64_sequoia:     "1433fb90267faee183558beda96870d8bde3396f58c5f519db24b574927ac8e2"
    sha256 cellar: :any, arm64_linux:       "987891180329ce3a37e9b8db235da409ff98a98179b596e3863d933b0be85459"
    sha256 cellar: :any, x86_64_linux:      "0508a7d1f72447f3124f766a058342de41210328a3bd68d99996ad14bad5a4c7"
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

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{formula_opt_lib("openssl@3")}/#{shared_library("libcrypto")}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", testpath/"ExampleReferences.bib",
                             "--export-to-bibtex", "UpdatedReferences.bib",
                             "--check-urls", "--only-check-new-urls",
                             "--non-interactive"
  end
end