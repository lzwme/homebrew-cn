class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.commartinvonzjj"
  url "https:github.commartinvonzjjarchiverefstagsv0.19.0.tar.gz"
  sha256 "d0b9db21894e65ec80fd7999f99023f1e65d15fa16b4ec76881247d9cd56dc55"
  license "Apache-2.0"
  head "https:github.commartinvonzjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9840ad0d07db532b0c6bfea0b8294cb133fd288b43dc4f4ce7ee56cfd5fe2d3"
    sha256 cellar: :any,                 arm64_ventura:  "021ee3e29a247ca68c15db0adad621405976ed98139f13c01698594dce36ce74"
    sha256 cellar: :any,                 arm64_monterey: "ff6e426aa0e5d2323796c89e004df6d14332453ae3d87739fc6d74fe897b335c"
    sha256 cellar: :any,                 sonoma:         "ad719df2af8a19ae8c41cac84d1e0ef491ad04ddcb58d4d0d037e25bc9cd41e5"
    sha256 cellar: :any,                 ventura:        "d970bba97e8eca1647c31430d281bb328f7bad8bf529dcdd8de23f5db90fa244"
    sha256 cellar: :any,                 monterey:       "1dc0314c65a1190c0fcc70366e5debec0052b02c041b29e904205684929eac69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "298c4c602e6914b399ac9c7b9ef26a0ebd1b0c04b93764d7cfd81e3d183adcbb"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"jj", "util", "completion", shell_parameter_format: :flag)
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
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end