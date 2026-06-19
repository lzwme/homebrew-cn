class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.12.7.tar.gz"
  sha256 "918777869dfb9465091f0e1be06cda71301208defe470a405e86c2e25f8cafe2"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c1a084fefb4cc6f1aaf1a5ac42e7cd01524b0bdee1ee7d2c700204cad04b848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6162c89adbaad441dfa2f4dbdb84bd4dc8d463bcf22761ea470a4a4132457987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6ac92c52c294a90f0b895d22239990b3264ccd2453b073661c3b2db31f6e263"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8bcc160cae5ae8471fb7f449a275cc1e3856105a1e43b5e506a6ff941e74518"
    sha256 cellar: :any,                 arm64_linux:   "59d6e684be9b90f0347250eacd2049f211bd596ccc8cfdfd658f4eb2036d89f3"
    sha256 cellar: :any,                 x86_64_linux:  "633a70e4c66269c9e51342173cd6d4f9b5e8977eb00b98398273d097601023a0"
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