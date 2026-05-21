class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://ghfast.top/https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.23.9.tar.gz"
  sha256 "c02da6b831aa5b80eb7b3b23589664db41037dbf487aaef989db6e8a2044af26"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2aa914b3aa8fb66d7f7901402d1063d417a587c42ce5fd76e3c539e37eb491cf"
    sha256 cellar: :any,                 arm64_sequoia: "0a61c0ee158b06020418e804c5328c9a1c198f08946dc0c1d8fc0581f1f50a21"
    sha256 cellar: :any,                 arm64_sonoma:  "c632bbaf644fbe5e0d6aacf95a4730f02dee6796d86cf3522c7bd3c51716ba6c"
    sha256 cellar: :any,                 sonoma:        "2a6bff9c66c505651dcce00dc8ec8be4f94f7935e3c3638d48d7ec8b3a8c193c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e264007dd9432106ce7ceac3c29c43d47ebf5c59e2aa3f74d01139fa28b70126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fea1903b4e2dbe113512791adf90b3ec11952953143336de15b0fc3f1c0ff4d5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utils/linkage"

    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_path_exists testpath/"brewtest"
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end