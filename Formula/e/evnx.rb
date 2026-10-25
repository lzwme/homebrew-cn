class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.18.tar.gz"
  sha256 "75ecc4b73faa82ddd6391dd35c9c605fe4f3d4f2839147036ae83fa3f4c537af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "daf1700163be0d430bf86ade882b0ecb09c66c215a39e0a607c893dd01ff68e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5429f52cb74b4a2f7e26aab604bc02da406970dc7b73ac524d63bd949e3cd5cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d78510e744a7807b9afcddea2ab16fd0a5e78695d9b11d234b91e2525e992d89"
    sha256 cellar: :any,                 arm64_linux:       "6756c36dfcb85b05c6bc0466a6759858f5a6e7bc3477b38414ba847ed8f7379f"
    sha256 cellar: :any,                 x86_64_linux:      "acb0eea3942aab31779f4852326e9873af2134a2157f12dff53051e19ea95b9a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end