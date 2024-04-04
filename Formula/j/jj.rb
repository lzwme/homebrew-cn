class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.commartinvonzjj"
  url "https:github.commartinvonzjjarchiverefstagsv0.16.0.tar.gz"
  sha256 "e6094982c8e5902c33b0505bbb0e4e4c35c249f2a36108655002dc7d06de7d4a"
  license "Apache-2.0"
  head "https:github.commartinvonzjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a8df8b6890bdb04584664c30c9b9b37a4d7027e87f74d43f85860059843ee1c"
    sha256 cellar: :any,                 arm64_ventura:  "b15a4946a3f2140fe59f22e92cd00dbbaef8cf2cf39a9375de64f76657907c25"
    sha256 cellar: :any,                 arm64_monterey: "cddbcc134c634a25f037b0eff58b20ba075e7ff0a6387c083adbcb173dedd395"
    sha256 cellar: :any,                 sonoma:         "76f6ed7cdd596dcefc23d7fdbfe1cc691799f723a61c5e60d3df76c8f215e7c6"
    sha256 cellar: :any,                 ventura:        "f7458565721f5843ebf98acc94ff20818d989dda591ebbf4cb65170e41867d6c"
    sha256 cellar: :any,                 monterey:       "3ad1ca186b983b340dae33a349b33e7809149acda4e933fe9f905f97d7bc4fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b230f9683f740e0bf4fde6b6ead4b98a6e5cb2c237c1dabced7fb2864089a79"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args(path: "cli")

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