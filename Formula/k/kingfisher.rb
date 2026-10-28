class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "a9644a42f8c1cbc32133d94f1fac84bcccbd3c9d7cbe454349ac9ac057fe3e73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ed1c9949f6e596bddf77c8343e94be00b3fdc041e415104dcadec3cffabafa71"
    sha256 cellar: :any, arm64_tahoe:       "24314e13e88b96eb572f3e9f347d776b5d8d22aa9bffd4362217b5f7e0458210"
    sha256 cellar: :any, arm64_sequoia:     "fc4e69b68e7d06e45b5b32141f410cb5c3fddf3c5fca32cc5e923d974cf2b7f8"
    sha256 cellar: :any, arm64_linux:       "cfb4ae865d67440604e53b4df1343f1142da51e2085f5481952362b9154e8bfd"
    sha256 cellar: :any, x86_64_linux:      "bfeba32857784a9b1c326c16b8b0ce55b42f2e8d7ac005986db0a819e00c8fa3"
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