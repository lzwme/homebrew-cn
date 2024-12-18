class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.commartinvonzjj"
  url "https:github.commartinvonzjjarchiverefstagsv0.24.0.tar.gz"
  sha256 "c0e92ec25b7500deec2379a95ab655c6c92021cf4ccb29511fee2377e37b35d6"
  license "Apache-2.0"
  head "https:github.commartinvonzjj.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "451e4de3460fd317c0abffba2de1fee65cd591b35234ae5f7403e15390377f3f"
    sha256 cellar: :any,                 arm64_sonoma:  "e7c846f8838bd8b26a669f96828fc21abb989b24ad80d52df258fefee24e8eff"
    sha256 cellar: :any,                 arm64_ventura: "6e1dc53f17238e3d4e9fc17a3f32ce34e92c326da591d207f61a3e788a413dbb"
    sha256 cellar: :any,                 sonoma:        "c8fcb58a6cfd101a2bf1dd120e0a730282bdfff72466f0f7269a60a9df9ec048"
    sha256 cellar: :any,                 ventura:       "9ecd891313a9da864069246d65c963a127a31b8bbcc3785ae436a4ef625f2265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de02419686306776565fad7a075e5f2e94cdd905bd729d394fd8400fd4ea2453"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
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
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end