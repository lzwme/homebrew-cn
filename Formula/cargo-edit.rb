class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://ghproxy.com/https://github.com/killercup/cargo-edit/archive/v0.11.11.tar.gz"
  sha256 "9ce140e840498d61c1573ff4206214d0c41c8db24048f0f0f27b7f4464310f9a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d817bace842bff98d813c3eefbd98b0daacba5c210a138ef82a0e9133c875258"
    sha256 cellar: :any,                 arm64_monterey: "e200c1d24ad4bbe5024a19694dd28258ffd7ec8bdce55645e0e484036073b270"
    sha256 cellar: :any,                 arm64_big_sur:  "42c10461879fa3164bcee05ae627b4bceeff5f3e7cd3d750eeeafd33c79fae6e"
    sha256 cellar: :any,                 ventura:        "4ced8f095b25e859d66fb14397f4a8ed3f925049c3ee9a4926b8b2b019d2725c"
    sha256 cellar: :any,                 monterey:       "508aa1b76ce67100a86c4ed254f030c55028559f7380ef6d73daa2c76771f1df"
    sha256 cellar: :any,                 big_sur:        "b666e10188438d3ea58f76281756400a08a9abd5a8939d0e38097830d0929ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1ccc4145ddd622a00d8d640b0683961d17195040beabfa581c66386f852218f"
  end

  depends_on "pkg-config" => :build
  depends_on "libgit2@1.5"
  depends_on "openssl@1.1"
  depends_on "rust" # uses `cargo` at runtime

  def install
    # Ensure the declared `openssl@1.1` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Read the default flags from `Cargo.toml` so we can remove the `vendored-libgit2` feature.
    cargo_toml = (buildpath/"Cargo.toml").read
    cargo_option_regex = /default\s*=\s*(\[.+?\])/m
    cargo_options = JSON.parse(cargo_toml[cargo_option_regex, 1].sub(",\n]", "]"))
    cargo_options.delete("vendored-libgit2")

    # We use the `features` flags to disable vendored `libgit2` but enable all other defaults.
    # We do this since there is no way to disable a specific default feature with `cargo`.
    # https://github.com/rust-lang/cargo/issues/3126
    system "cargo", "install", "--no-default-features", "--features", cargo_options.join(","), *std_cargo_args
  end

  # TODO: Add this method to `brew`.
  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      EOS

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system bin/"cargo-rm", "rm", "clap"
      refute_match(/clap/, (crate/"Cargo.toml").read)
    end

    [
      Formula["libgit2@1.5"].opt_lib/shared_library("libgit2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
      Formula["openssl@1.1"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-upgrade", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end