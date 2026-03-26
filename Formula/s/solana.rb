class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://ghfast.top/https://github.com/anza-xyz/agave/archive/refs/tags/v3.1.11.tar.gz"
  sha256 "03203cefcabef0c16f309047d577b27db81cc31cdf59551bd4f8f64ab898ffe7"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "03a19d52b40ad5ba9c361684323ebb15b856d06af51477f8c37a0aad9d8c696e"
    sha256 cellar: :any,                 arm64_sequoia: "8409ef553324c036d4adbef98768164a5d8af26faf38dd73caf3e083b172d18e"
    sha256 cellar: :any,                 arm64_sonoma:  "577165c98b21d1dc8de83c3d38116a3bcd49902d952a9cb615abf1761b67b31d"
    sha256 cellar: :any,                 sonoma:        "20a6d4412c008662941f7b421276c6077faea127694983f5a48f33b1f792cc6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe13435a4619971ac29a1252ecc652241562b1b0846d2ae744b590e13464cda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "071f0018c89949549eb0a6d56267e777d8a393a033751c2313998d6673b518c5"
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
    ENV.append_to_rustflags "--allow unused-imports --allow unused_unsafe"

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

    generate_completions_from_executable(bin/"solana", "completion", shell_parameter_format: "--shell=",
                                                                     shells:                 [:bash, :zsh, :fish])
    # `:pwsh` string is "pwsh" in the shell_parameter_format,
    # so we need to write the completion manually since solana expects "powershell"
    (pwsh_completion/"solana").write Utils.safe_popen_read({ "SHELL" => "pwsh" }, bin/"solana", "completion",
"--shell=powershell")
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