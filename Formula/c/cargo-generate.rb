class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://ghfast.top/https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.23.10.tar.gz"
  sha256 "3cec2d0a6fe45fb6bb4d1341abb1758cc799a348bd5e59b3c0551e4dabe94369"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ccf195fbc3a555ecd6802f2adc7e1b0739fc0568b30d2252e016cf712e2f19ca"
    sha256 cellar: :any,                 arm64_sequoia: "c34a5774385311cc9f25b3608f9f145919ff83c7c6d3ef493d77c59aec82be8c"
    sha256 cellar: :any,                 arm64_sonoma:  "6a82339ae502bc5b7e24c0b1676d564b8edb22698cc6eb8202fc2b82ae839f5b"
    sha256 cellar: :any,                 sonoma:        "d0eaab10f2dac54239f8d6f6c77e2d976baffde29a5d3787d9661b98d1100909"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9850328368f989ad58c60035d8b7a95b1fb20b7b06e6a5fbf959551d9c9bde9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f32eb7fe2a1621cbbcb96d9eb63c833177f91249871b119e93cc453fdf433a8e"
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