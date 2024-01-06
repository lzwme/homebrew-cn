class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.commartinvonzjj"
  url "https:github.commartinvonzjjarchiverefstagsv0.13.0.tar.gz"
  sha256 "f4e2be834cf9ea966ac58451298c8f1eed145c190fbca62b5b5a6bd145ac997e"
  license "Apache-2.0"
  head "https:github.commartinvonzjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f1b3018f5851dbc0484c47145a653ef0acf12b29bbede36bc56e0ecbafa0cce"
    sha256 cellar: :any,                 arm64_ventura:  "6a5df7e031cf127c6c1bb22174e01f263eaf194e13bf15472887ef77813b1061"
    sha256 cellar: :any,                 arm64_monterey: "e88f57256e00fefc7c2e2ad00c7fd6b103631bdc92a2e3a394f581bef63efafd"
    sha256 cellar: :any,                 sonoma:         "2ee76b3afcad94a449e99f1483fdeaf059ea76e48841f4f027ea881f5873a514"
    sha256 cellar: :any,                 ventura:        "b5b7a675cf30af3ea4109bc2b260cd98b28552569b935671bb42680290edb793"
    sha256 cellar: :any,                 monterey:       "43eef7d525ad445b60ece4a0ab8ca9b220f8d86835efe612f56d0bd79c7445dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "852b18fb5d98684a0196a79553daf2fc01db6b32df574ad457550de4a806dc96"
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