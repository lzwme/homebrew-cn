class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://ghfast.top/https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "009ae09728f986c9fa8c9c3df64f00af8db4c9cf0bb212c40b71706355671752"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "495e1a16fd8fd0dd4d2628c65324a6710bf1fe41ad41698432a602d3291999bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c81bfc9b3ad8ad3f5cc96cd14987fe27224640a208d676ae7cb5e18872d3fbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e7160b734ee64c7260e1302da5423fcb5fb3df4101f8d3c3dfb784be0545d6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "24f3e086735e3740ddce3de052db5c90d4cc02347f8e0910d094505c71cb898f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3be79121ad80404f765793f57201e8f0cd39832240514a72f040b28c50a0550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "570f4d8942c94874c35e1e0075cdb4e5e10919de8c676b69f5f9b661564197bb"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end