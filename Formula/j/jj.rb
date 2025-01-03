class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.comjj-vcsjj"
  url "https:github.comjj-vcsjjarchiverefstagsv0.25.0.tar.gz"
  sha256 "3a99528539e414a3373f24eb46a0f153d4e52f7035bb06df47bd317a19912ea3"
  license "Apache-2.0"
  revision 1
  head "https:github.commartinvonzjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3584b23773db2bcc2f17d0e9ab7e43cbcb75666a7c426f30bb2353c502dd692a"
    sha256 cellar: :any,                 arm64_sonoma:  "180144fac0063ecebad0df2e169d1454242b9d289e0926c939a0af66d0615f31"
    sha256 cellar: :any,                 arm64_ventura: "c465e088aac79ff328457d4343408944f1cb6398a67ed4fb1d9af6029ddc78ae"
    sha256 cellar: :any,                 sonoma:        "751941e6f433db1ea77b7a6dfc5680c45ebdefba203901fdaa73d37c83c6707a"
    sha256 cellar: :any,                 ventura:       "3f105c85f77c9f739f958b280613afccfb54477710d8085d3f18169d4b40e4c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e78f9c71743a969303d52e0a493aaee12b954df16ed1e0a85a03b2241a61cf00"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"jj", shell_parameter_format: :clap)

    (man1"jj.1").write Utils.safe_popen_read(bin"jj", "util", "mangen")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin"jj", "init", "--git"
    assert_predicate testpath".jj", :exist?

    [
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end