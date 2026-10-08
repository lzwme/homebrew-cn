class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "6bd9a6eed4a24ba2bfd0323cc9733ec5b3da6a3c15ef891903134bc4b440439a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8c6c9b3577c19a9469533aafaf1203d18e45c7a87d255b04dd270af18c3f539b"
    sha256 cellar: :any, arm64_tahoe:       "6a659ac00235ea891172c72b77d6b4383cf3f3df21855c2421b5306331415a07"
    sha256 cellar: :any, arm64_sequoia:     "e741d820a36931a0382443868eb8d2ea7c5d875adbe82776bfcf17403ab3c11f"
    sha256 cellar: :any, arm64_linux:       "a85bfc1d4bf344595d255ddbcd79f04f3f69699f4ec468fec6e69c5f48b83ea4"
    sha256 cellar: :any, x86_64_linux:      "feb2cda71c6f8de05e180fdfdbb2b3d399a6bd3710547c7e2356857d773701eb"
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