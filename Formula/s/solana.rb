class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://ghfast.top/https://github.com/anza-xyz/agave/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "a1ff6f5aee5702c53feac14f7fa82209a61a7a3cbaa977148b06051fad7a72fa"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "387b15bcdeeda4554333aa0d2e292cb49f735c5946ed87d9a80867575a8ebce8"
    sha256 cellar: :any, arm64_tahoe:       "1dc94776caff8b7fc29ecd5befb1db273dc440e0e694dea0eabe03801057b51d"
    sha256 cellar: :any, arm64_sequoia:     "3c45be12410fd2e0d15c97b2dbe5fad48a97f0a3db0967749ff1853c1cc9fbe0"
    sha256 cellar: :any, arm64_linux:       "73cbdb3f87449c2e0c6042abb81c80122657f9bd57799bce6c6d15587455b2ba"
    sha256 cellar: :any, x86_64_linux:      "8682bab6dc764b126e66566ac0ebfa7164dab54d1fa6e4ab69cf155288328288"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  def install
    # Work around librocksdb-sys build failure with Apple libclang, "Library not loaded: @rpath/libclang.dylib"
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s if OS.mac?

    # Use brew dependencies
    ENV["PROTOC"] = formula_opt_bin("protobuf")/"protoc"

    bins = %w[
      cli
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

    generate_completions_from_executable(bin/"solana", "completion", shell_parameter_format: "--shell=")
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