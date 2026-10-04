class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "d98dd11d6ed2546f95f0d5f7404971148fb9f5d6e1e0b2b61168692138f640a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8e13ff8fe5b08375a831a52e9a6e7da099be66990b49fd9bbf5f271b0b1af2c2"
    sha256 cellar: :any, arm64_tahoe:       "63b820fee1e1cce88156f601eba475a0de0d7ebcfea4edf559df8218220faee8"
    sha256 cellar: :any, arm64_sequoia:     "099beca67403568b2522b4052c8209905d8af2bc21d4d0bd8d0b20793b389388"
    sha256 cellar: :any, arm64_linux:       "88d31febcfd3afa05268973f9751a3a1af1e005e0744f678ffadb63cad804a1c"
    sha256 cellar: :any, x86_64_linux:      "3193338a0b30ad8c0e7f81cc953c5387793cddd4b44a696a6005cd7aa4ec4ee8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "vectorscan" => :build # kingfisher-vectorscan uses static library
  depends_on "aws-lc"

  uses_from_macos "sqlite"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["AWS_LC_SYS_USE_SYSTEM"] = "1"
    ENV["HYPERSCAN_ROOT"] = formula_opt_prefix("vectorscan")
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"

    args = ["--features=system-alloc"] if OS.mac?
    system "cargo", "install", *args, *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end