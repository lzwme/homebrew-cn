class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https:github.comastral-shuv"
  url "https:github.comastral-shuvarchiverefstags0.1.41.tar.gz"
  sha256 "17c9e836e7732f049debd355aeb4842cdf172c136bfbc2f62018531c4be7d506"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comastral-shuv.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0feb4c59dfbab4f2cc1b5196ef086d5741237054541e8e4358914430f5c21199"
    sha256 cellar: :any,                 arm64_ventura:  "06e7ea0ea216c838a8cb18d53bfc0ea0b4d96e845ae85f36f5c6ac4b993978b2"
    sha256 cellar: :any,                 arm64_monterey: "4a209543c7ec1a02e5993790944f7ae8e151cec082e316e55140498045cc0c1b"
    sha256 cellar: :any,                 sonoma:         "610cab9481f343471de4a3a76694709905f0502598a963c8e5c9a8475bb484a2"
    sha256 cellar: :any,                 ventura:        "4d43a8ce966b830afa3c5065e13b764bf4cd058578d2d2c77cd3acb312328a9c"
    sha256 cellar: :any,                 monterey:       "3736b8c73e87cdd0167d4f1a1a8d5c7e43153a5d171b8f13783d3bb9e785498f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35652661a18f9f5dbc58681c20c19a02f1946c6de9d414ec756a261363260d27"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "python" => :test

  on_linux do
    # On macOS, bzip2-sys will use the bundled lib as it cannot find the system or brew lib.
    # We only ship bzip2.pc on Linux which bzip2-sys needs to find library.
    depends_on "bzip2"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesuv")
    generate_completions_from_executable(bin"uv", "generate-shell-completion")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    (testpath"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"uv", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end