class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://ghfast.top/https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "66cbc952512890707a1ab50c26e59d93c382500b1c9a9e88974fef3cf647f29e"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bb1553b484f621b686e9ebe68c8bba4bd51e55509d336c6a903fd25bb288d36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3265f4e7d97b366f2e9c7287ec143bba14b924bcc4127f1f3e6e7fa5d025287a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54db662ccab98afb00fc5f0ef420bd393183bca86ccd5d9a8b9ebc848231f6a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "750d6ed58ed0710485a66e7e3bdff93328bd3215c151f14bea65ef18552a8b58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1b837c3937c17bdfdea483c5b6be993bca8f5815b5923446568d1bff71a6159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42e75f1661760a222d16674455e8c758bc03ec2769d5228e550f38f7e883ee38"
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