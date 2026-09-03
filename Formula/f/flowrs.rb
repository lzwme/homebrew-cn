class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.15.0.tar.gz"
  sha256 "b00f0153e5741a0904e07b848ee4cf1a0850b2b431a4a942ae816a82ebecfeac"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5188dc199c9a1b3ca62c574c564b2a836718519eb48ff8f6543d24dd3d996334"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c1adf82a7099219477e2304b1d5c7cdea6d741fa319c171930a6c624a8134f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb6a8dc78d5cd684497aecff39a5d754cb7d89fae11a3d36b4467bfedabf0659"
    sha256 cellar: :any,                 arm64_linux:   "0a62e55b215ebb88b3950bd5d40097af0b1a1f3b04110e0ad95e56c6bc66ad85"
    sha256 cellar: :any,                 x86_64_linux:  "f211674ddd3524f94c16bdf24dfafca1a49f0e3b1373322276a5873d5dd5a44e"
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