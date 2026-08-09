class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://ghfast.top/https://github.com/anza-xyz/agave/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "d930bed517181fae7d1d31f699e534d97b207e066831163f0083d8abb90e718d"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c9a9ec02cece97dd67b0ed30afa476760a8a19ecb3e290c6bb398d7b3211b062"
    sha256 cellar: :any, arm64_sequoia: "6f0b064fd1d6a81d719050d29e469b11e4d5b846d63fd2070b382c20da593e81"
    sha256 cellar: :any, arm64_sonoma:  "adc9574bd61b2934b3c79a357b8bfb625bd4661b8f2ce4382569176f33d6154a"
    sha256 cellar: :any, sonoma:        "ad633aa9913eca94204a6a6b79b1bc7c30ac122ab06f2989a409331891919639"
    sha256 cellar: :any, arm64_linux:   "823c844525aca2a1b8b104a73209a601694b67041b86c5490012637780f0f70c"
    sha256 cellar: :any, x86_64_linux:  "d0c186e596812e36daf87543503cc472d701906a7ffff3e2b364b3057e4bf8b6"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "rocksdb"

  uses_from_macos "bzip2"

  def install
    # Work around librocksdb-sys build failure with Apple libclang, "Library not loaded: @rpath/libclang.dylib"
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s if OS.mac?

    # Use brew dependencies
    ENV["PROTOC"] = formula_opt_bin("protobuf")/"protoc"
    ENV["ROCKSDB_LIB_DIR"] = formula_opt_lib("rocksdb")

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