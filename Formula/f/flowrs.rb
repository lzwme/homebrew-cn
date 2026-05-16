class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.12.5.tar.gz"
  sha256 "db5c69746918643745dc7a240fd77547c8cb1157d34b1610042bd9e78c5f5b97"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f60b8d92392b3684119eac2af7cfae995d3e341bd097d80b2cb953948042e57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fee6b5ece6c6dfc256916259a7bbf22afbaa5c822143a40f03526420a8648a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5be1d4ce2b760a4a3f6c80c9b4facc964b977866e32b8597703207b49e18fc37"
    sha256 cellar: :any_skip_relocation, sonoma:        "31b21163185e4c3cad90f27e1ecc2645c57fd643dd46a8daf1e3df88c9db20ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e54159eea40baa81bf569c8d7049243750cadd0d81e0a6d4353d9a1f5326935f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1dd45dceff574ef45902c94c8ec76794779f94d8adb082b9cf55d021a70f562"
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