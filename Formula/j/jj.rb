class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.commartinvonzjj"
  url "https:github.commartinvonzjjarchiverefstagsv0.19.0.tar.gz"
  sha256 "d0b9db21894e65ec80fd7999f99023f1e65d15fa16b4ec76881247d9cd56dc55"
  license "Apache-2.0"
  revision 1
  head "https:github.commartinvonzjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b2fb06c3fd10752d1bbb55effb7cae8df02c1cf5825ea725b2764e905578efec"
    sha256 cellar: :any,                 arm64_ventura:  "ecfbcd771ce2b2ae36f6ee3fd3596d41bc395985c23b818b3a5cc35c1dbfdcf8"
    sha256 cellar: :any,                 arm64_monterey: "d77d2f23141aa1f4428c911d72c8b2b9993fe50f94b9d9c2e4d7a08c5159ea8a"
    sha256 cellar: :any,                 sonoma:         "561ab4c5b883edbaf8e9c1723e3c538c13a2362c903a240aa5fcd6bf1b5af158"
    sha256 cellar: :any,                 ventura:        "f1930afd3343c88d1bd58722811f8a2f0dcc73d066f9a17ea3d804d5b39f6f74"
    sha256 cellar: :any,                 monterey:       "d4c4ffe83c3dedba16942c09d6bda00cf77f9b8828c6a655a175dbe10b52df60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d006a9a23ec7b357aa2f36d72513466a9d2f29568a0d73ace0fea51f9232973d"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"
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
      Formula["libgit2@1.7"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end