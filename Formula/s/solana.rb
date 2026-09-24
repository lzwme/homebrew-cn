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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "2b48bc9caa17acdd22c5575b08184f474b5dbf24189db8b0051325c18de97e2f"
    sha256 cellar: :any, arm64_tahoe:       "deec13800a6e8d73656825dba34349dae8e58add925737a619dbef9fe032a3d1"
    sha256 cellar: :any, arm64_sequoia:     "f7685d7c922bfa69ce48bdd9b7af86e22bd0e617d7e5190a3adc32823354352f"
    sha256 cellar: :any, arm64_linux:       "772c7a5443f136d6afd641324f069dc5e558d6acfb2383d8c6ad46010ff42b60"
    sha256 cellar: :any, x86_64_linux:      "362861878c708b1732f901fe26960c9e8d162e7d3cd64bbe325dab810c6c2817"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

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