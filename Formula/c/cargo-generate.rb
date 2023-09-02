class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://ghproxy.com/https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "830c9a6bc6350f47e854260291d7303b8058659f8e03b85894f5636ec2d69b17"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "791a92ebdb3cf161da2b1413b6208ddb9fb59bef74be16ec83764ebcf0c386e5"
    sha256 cellar: :any,                 arm64_monterey: "f74825395f0857f6b3fea510d7b9c7842689250f44863cad71948209728763fd"
    sha256 cellar: :any,                 arm64_big_sur:  "7757aef9ac22d7281caa3292df1f51d4cee35907ec8005eb6b9f4edd8d1cd84f"
    sha256 cellar: :any,                 ventura:        "4a08f08e3bf1e508da6dbfe71eae3d159277b2e80c68a76c228df076ab394620"
    sha256 cellar: :any,                 monterey:       "f4a0b758f62e76b606944bb82821a22edd120ea140b78e54afad31e8f2ced419"
    sha256 cellar: :any,                 big_sur:        "fae60e4ec6cbd26eb15b0acc99e9af9080b3836a0d0388126b211be5072b7813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b89a4aba4a58ca7e913561633f56b805ce55e43efe220d5e9eff61926f2a151"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_predicate testpath/"brewtest", :exist?
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end