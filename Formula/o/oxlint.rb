class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.86.0.tar.gz"
  sha256 "6bb8bfdca1702e98f4e247c18924e8fe3f2fa6204bb56d26635bc7b88d782e87"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7eaae90e779583daa1f89006f430c1d1e8ce03fff2a9f016df74505bec00d50c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0dfc19365ca7145329765a5ef61da188bf15b425c7799a1526b55bd942e614db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "627e5982db4d1e0f3ef5e0513caa480bc14231f0bd84f6d165e29ffb999988a4"
    sha256 cellar: :any,                 arm64_linux:       "7042859379d4ac45ba0bb256a37612e581f62ac007ac590c72ad2f8f691dc53d"
    sha256 cellar: :any,                 x86_64_linux:      "3b4d8bbffaaaf442de33edf68f35e967285e52cc5dc3536d76b66633a4891424"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end