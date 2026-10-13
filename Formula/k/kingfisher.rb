class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "b7e4679832363590d2f2efd07c60d6f8ba1df2bb92582b8e646592bbcfec0440"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cfc5e2b8aaa766bc1d6f584da8576c4449c39edddba06fe70df37ba3d2c4b06d"
    sha256 cellar: :any, arm64_tahoe:       "2d464bcdb80b0cdc32e59b1dbb3530a68c734926042583ba8dc99e56c44348c7"
    sha256 cellar: :any, arm64_sequoia:     "08a2f90917dadaeeb4faf924717da527f523883a2f64288061645d1ff6a9c305"
    sha256 cellar: :any, arm64_linux:       "128f1935486225b4f1fce1a73ff1bcc6d1af54f9b9add6acea134ba9c383a6d0"
    sha256 cellar: :any, x86_64_linux:      "44416643f76e39112d8425214d4fcfe4a8fb48477848261ddf422f0ea1f2f969"
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