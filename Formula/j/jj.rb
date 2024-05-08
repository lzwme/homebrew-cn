class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.commartinvonzjj"
  url "https:github.commartinvonzjjarchiverefstagsv0.17.1.tar.gz"
  sha256 "653e1190a82a39dae733487a11aa641ba62a36ae1e221c21844f822575961919"
  license "Apache-2.0"
  head "https:github.commartinvonzjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e0826c2f41c7a7f204909a09a712f92a341959829607d6e85c29fea1b9de696"
    sha256 cellar: :any,                 arm64_ventura:  "f1015546a2a2059df89d27faee0665d35139aeea05a3deb90c2eda0e097008ae"
    sha256 cellar: :any,                 arm64_monterey: "cad3a1ff6da47123c7b1e2033f3c4189223a3f957262955075d7a8162407eebf"
    sha256 cellar: :any,                 sonoma:         "9531fbe0aaf607f5ee9efecc0f01b28def587617fcc25529123f3a0529d757ed"
    sha256 cellar: :any,                 ventura:        "7bc0970db1defcb0e226fdd9141ebf8915f69196f6d5e11609ce65210b6e65ef"
    sha256 cellar: :any,                 monterey:       "3172c9cb1d6760298dd7acfdbe7e9dc7b77c79c3f3fd0d17596fcc6595ec9ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcaffadb64e4654a1f8f3083f9499c6cfb6c43ef52da7e4fcedc6d64e5865723"
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