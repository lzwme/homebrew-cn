class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://ghfast.top/https://github.com/anza-xyz/agave/archive/refs/tags/v3.1.8.tar.gz"
  sha256 "ab4c83db509065c9e4a3d2ed61280206df41c4efb13d8087a261b2b31873be4b"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "147c7426b3fe385342475c4a7491441bcec15e9f73557cb26005c9c7505f677d"
    sha256 cellar: :any,                 arm64_sequoia: "ef22b3b53fdfceef8df23d81709a8ef534d0d38f97e1e2d2455140f4caddd69a"
    sha256 cellar: :any,                 arm64_sonoma:  "d7e5787e839fd3a7a61b4cebb02ee2e7b19a1be0ab503308aca084d1cad1247a"
    sha256 cellar: :any,                 sonoma:        "173638d6e7cf4f2869d3bb4f8383909089f39bbaa0df049747861b298326f53d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cb623cac73eae2ece4b4ae422dcf4594978e85402f81049d6cb652c12f2048b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dae4d079886974e4bd81cf42e808ddcdfb4843eaec624b6804d2f29dbc09525c"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "rocksdb"

  uses_from_macos "bzip2"

  # Backport fixes for newer Rust
  patch do
    url "https://github.com/anza-xyz/agave/commit/4b0384e8d7ffdb13c9e73ebdfdc8a0e1cc8ca290.patch?full_index=1"
    sha256 "ba8ee2f0624fe83fdfb0d198d840a115f546924d345029afda344b5a57c57f9e"
  end
  patch do
    url "https://github.com/anza-xyz/agave/commit/8f3944b2159112b8e017b41f9c834344b32a7c59.patch?full_index=1"
    sha256 "b5c59105fd9fa22f96a5135d3c14a61f63cbd86b31f509a06574965520c11414"
  end

  # Backport disabling LTO to compile with Apple Clang
  patch do
    url "https://github.com/anza-xyz/agave/commit/5e900421520a10933642d5e9a21e191a70f9b125.patch?full_index=1"
    sha256 "5a03a89dfcb91a3b579e1f67a78580f626c6560e8c6a46c371d7297665b22360"
  end

  # Work around Homebrew-specific issue using Apple Clang 1700 (LLVM 19) by updating cc-rs
  # https://github.com/Homebrew/brew/issues/21112
  patch :DATA

  def install
    # Work around until new release as fixed upstream but commits do not cleanly apply
    ENV.append_to_rustflags "--allow unused-imports"

    # Work around librocksdb-sys build failure with Apple libclang, "Library not loaded: @rpath/libclang.dylib"
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s if OS.mac?

    # Use brew dependencies
    ENV["PROTOC"] = Formula["protobuf"].opt_bin/"protoc"
    ENV["ROCKSDB_LIB_DIR"] = Formula["rocksdb"].opt_lib

    bins = %w[
      cli
      faucet
      genesis
      gossip
      keygen
      stake-accounts
      tokens
      validator
      watchtower
    ]
    bins_dcou = %w[
      ledger-tool
    ]
    (bins + bins_dcou).each do |bin|
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end
  end

  test do
    output = shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match "Generating a new keypair", output
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 045adc06b4..5ffbb89f1c 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1720,9 +1720,9 @@ checksum = "37b2a672a2cb129a2e41c10b1224bb368f9f37a2b16b612598138befd7b37eb5"
 
 [[package]]
 name = "cc"
-version = "1.2.16"
+version = "1.2.21"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "be714c154be609ec7f5dad223a33bf1482fff90472de28f7362806e6d4832b8c"
+checksum = "8691782945451c1c383942c4874dbe63814f61cb57ef773cda2972682b7bb3c0"
 dependencies = [
  "jobserver",
  "libc",