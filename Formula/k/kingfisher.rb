class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "6e0945db3605c7f4bb74b1bd5a0b1a36052a0118c291dac9139daa3db16e269d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4e41e7e898bdf618da6ab4566a126fa6c743ec0f3e692b7d7cf1df2fd7572306"
    sha256 cellar: :any, arm64_tahoe:       "d797d791550ccd1a50ce4e629dc01ffa493c605ebb190214e2199c054651ab93"
    sha256 cellar: :any, arm64_sequoia:     "79b8fed55982f7d19e817436d04b094a8f40fdc336e1fdcaaa83df6e87f0e0fd"
    sha256 cellar: :any, arm64_linux:       "e27f7b5d1f3ba1f500bd842e329301fefd1c5ab31835418f1c17d94c8757baea"
    sha256 cellar: :any, x86_64_linux:      "ec34d8d2431a16254bc88c3edc152ab010e70d0121a37045911862fc3c0fcecd"
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