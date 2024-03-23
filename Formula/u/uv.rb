class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https:github.comastral-shuv"
  url "https:github.comastral-shuvarchiverefstags0.1.24.tar.gz"
  sha256 "31f4462aff2b7ed56994850c587bf7743f4c4844591c03a2e9618c0781ec225e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comastral-shuv.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "05a025b4c9e520b56fdbf4b9f1f7bfc36413b7f6781533850c4045c9ada64e47"
    sha256 cellar: :any,                 arm64_ventura:  "826be4bbae1644ecfc19d728569b845395d303dcd1cdc5f3d19bdccc200849b0"
    sha256 cellar: :any,                 arm64_monterey: "ae2af6aed9b58eb0489d33dca8df895840471b6ae5183be64ddb29f22bfd632c"
    sha256 cellar: :any,                 sonoma:         "90301f068445b033cfd7e8ce9a1c6fca393d517a48874ac8734e3324f1867550"
    sha256 cellar: :any,                 ventura:        "1c84346683a396826bfbae54ba141774bb9ddee98eff3c3b1328d3cacaeb8fa0"
    sha256 cellar: :any,                 monterey:       "ed0aba48267d02c51586c7eaac1add72d038379677b92267d9fc06507cb1623b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb64625b998ffdebad02482feae08478138affa808f056711dad109dd73e7d76"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "python" => :test

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