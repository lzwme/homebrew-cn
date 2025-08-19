class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/hk/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "3ee19342b7f2149aa7fda36fdf14df9c5a5a02281de65c5c354325b80ee76776"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "69157b9350a77608972b6f7a690c9f207d23e89ae507f33edfbee461e58b79af"
    sha256 cellar: :any,                 arm64_sonoma:  "ecad97699dc9a6938f5f295feb173feebf7f7a7febc6a4fd9f6221cfc7e5332a"
    sha256 cellar: :any,                 arm64_ventura: "9d3f4c94db6228a98a59b3167e37968b8c887404e4a10dbe15883a9bb0c35e58"
    sha256 cellar: :any,                 sonoma:        "ab79fbafd44043844e1433bcc9c0a265893ca5debe25b118d643805904d5f4ca"
    sha256 cellar: :any,                 ventura:       "c8d6204db017647aed03e37c4da524a94086e7280a97f87268951215635da4f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c427726b6410c2340a098c394715ce5f80af970beea8d59d6309f6194d87e242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2083887d9bf03ec69e5cce3e10abc1a50487fe266886a19ee49185d498d58de6"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    pkgshare.install "pkl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "#{pkgshare}/pkl/Config.pkl"
      import "#{pkgshare}/pkl/Builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = Builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end