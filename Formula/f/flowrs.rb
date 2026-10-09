class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.16.0.tar.gz"
  sha256 "7a0c69f6b780e49be80d67d6863e8f175273e74b08acdeb3efcb2a6381ef29e4"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "268d6d8fbf609afcb148735bac910abe182788b4a2b8e9da0e71f25d224339ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e598ae1e22f76814ef4a9032bb7730d098e69b919951c82d5ab175f8cd38412"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "858916b666a23e90514456c437667cca1b139f28dea92ae8f291cdc9669bf9ee"
    sha256 cellar: :any,                 arm64_linux:       "0be1041a372157efd7fb1e404d971afde20e0b0b98f69b3d79e4c3f85060367a"
    sha256 cellar: :any,                 x86_64_linux:      "97793b282aa2ad464f91fb26f564972f9c6a22f4ac887604751c3628aa58f60e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end