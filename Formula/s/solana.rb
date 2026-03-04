class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://ghfast.top/https://github.com/anza-xyz/agave/archive/refs/tags/v3.1.9.tar.gz"
  sha256 "7b025d4f341c9ec5a611ff7f9c159770df33b79f5936fef53ce87f83b5068aaf"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39bf27dc2595c7810a9c1d6fc46e692f89e4c998ad012c17c1440581c17c2420"
    sha256 cellar: :any,                 arm64_sequoia: "18824ed0e51219508b2416146cbddc6f0290d4642fde82fdf2238a342b6a48fd"
    sha256 cellar: :any,                 arm64_sonoma:  "814c06b1f721b4ec8414c3557278f3610d3f2b63d3b8798b5c72b452bcc5cddf"
    sha256 cellar: :any,                 sonoma:        "96ec435bef33a52c8d9c9776212239cef06cfb4bc47b9604739b8cfa73a802ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73213d63cf965fac72eaf681809ccdba9224a22071921e52ae71aeba001be9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93d61f9989c4571fc9f81537f03040c00a4ff5fad5f5cbdbdd5f5b82c8812b78"
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