class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "5831881eed00a4e7995277977e3b3fe276bf6704613d41a334fcff75a9af96c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "05a84ec758dbd2ae7b120b9ed4a54e78b64cd46081921faab6bf1bcac15e9279"
    sha256 cellar: :any, arm64_tahoe:       "d53acfe3fa87686d2878aa71d3fcd1bbbc3795c24344499da16db94fb686fc88"
    sha256 cellar: :any, arm64_sequoia:     "3f83e02d346dd986430c7203cfb99b47d546f3814427682ccadade1b28387aff"
    sha256 cellar: :any, arm64_linux:       "57b04144fb62653d6eb8014dfceb1d8d56f98a2df45aef94b3112216f65e51fb"
    sha256 cellar: :any, x86_64_linux:      "60e64d199705ec8bddd4d75feaa20d3b7b1f024de055da546e3595fcbdb2f489"
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