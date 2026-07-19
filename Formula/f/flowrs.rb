class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.13.1.tar.gz"
  sha256 "a731a8fbd20153381d8133abcb3305e69fd1319801ed2adbb6c7e6f11f807bf2"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bea7521dac78e8effd99d1a124d2e5a5ce25dc49a00f77e6b76e9aa692cf45c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a5442de90386e14bf3ac7207b3315a75cbdd4cdcb63f978bea3a0d4cfe84184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edaed4f0d2642ec41e45be59a6ea6f894689fdd2dcf5aacd7a04bf3f368b7ecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e16cf1e7d627d0c546c929cf6ec4ae3881b65fb027706898e1a5cbac37e772b"
    sha256 cellar: :any,                 arm64_linux:   "9e5c63c81ac429bb32c63982e2b5ee75257cc73b574ea68cf47f3be033c7535c"
    sha256 cellar: :any,                 x86_64_linux:  "24b6489754462d99804cb5c953f568cf4e87fce8f803a47c2f456b6678ccce81"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end