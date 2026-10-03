class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://ghfast.top/https://github.com/watchexec/watchexec/archive/refs/tags/v2.7.4.tar.gz"
  sha256 "e45197341de95d89fec438444d209ffaef34f9cd8f1604a416f7275bf511d475"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7ee9810f1f675c2bfb1597ab2ccdc957e4fb6318f9b5b265835acfd866f40c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b9848f82871ac21f9e10599f2da1323faa2f19c1c8c50b5621ab939dd0f3d72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb9f9371f513ecb2cdc50964cc95b3720b16ad52be778b924e7870022bcbe1e2"
    sha256 cellar: :any,                 arm64_linux:       "119b2daf3bb309d4c9c29d8ac7ebd672862b3096968d7af1cf54dae0a23686c1"
    sha256 cellar: :any,                 x86_64_linux:      "e57aa37524e9139aecaa15422809c3ffca72ed8aee7dd7a126bb47e4257ec1b7"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"watchexec", "--completions")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}/watchexec --version")
  end
end