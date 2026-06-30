class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://www.anza.xyz/"
  url "https://ghfast.top/https://github.com/anza-xyz/agave/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "0078be7b61bcd38956f4bdbae0ec16eba92ef0db99c5ae502cf2f2a3897938cc"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8b3d59c204e3f1544d7b7677510d585476e864aea7fd416f4f78ed938ccabf6f"
    sha256 cellar: :any, arm64_sequoia: "7984f49d1af79ddb18d8e55be0d8ff84d4140deeb5ab0253ad325469c432704e"
    sha256 cellar: :any, arm64_sonoma:  "f23255dc80fc5501f05f60cd87d7367cc1c79fd9e5cefb940efda7762733e278"
    sha256 cellar: :any, sonoma:        "70a9b261e769b0ae76f95ae655e1e062a9ec94c142bbbf28ba62bcf190685d7e"
    sha256 cellar: :any, arm64_linux:   "c052f07fe36ba79105572cecf8a7e957aef5d54f3ea0f4e1adcf38a8aab60d69"
    sha256 cellar: :any, x86_64_linux:  "4192dbc322cc0004f4940c26d30666cb89868e23e87bf20aecf939385e4d0c7e"
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