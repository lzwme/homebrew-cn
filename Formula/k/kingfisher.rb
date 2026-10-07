class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "4b1325ecbeae3a4bc1371f9c6e0bfcc361305df3743f726257f15fc5bf84fa6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ab84b3127031c0bfee603d6f335b647d7ba77fe56d899309a06dd020d0547fbf"
    sha256 cellar: :any, arm64_tahoe:       "e1bf2b969ebb3abbf5f8c5f1ae787d4708b6e1a6340f8369fcef0b1cc282d91d"
    sha256 cellar: :any, arm64_sequoia:     "7722b75790735a9e68b716592199c9c4371db21c20543329d6b104ee81efcf57"
    sha256 cellar: :any, arm64_linux:       "90ee96924c907309325251e2f3f4e9adb0059d16ea72d79ba4726ea5a0281857"
    sha256 cellar: :any, x86_64_linux:      "b7941600c916f1e0125897ccc9e6873659dfa77163278d069ac4b64cecab0fc6"
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