class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://ghfast.top/https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "585d5f66b0feea56f27dc69031a4ac21bbf87a90fc09bc3c5fcc21486c06018f"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0e93b870c6a57e3c62d93c529f5073608fc481a7b114dfd7c8ee1abbea79b5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dcecbf00f1fa44196d3229e2e212f477326227de422e31b09f7f9da983abbde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ddc004c31a9a1ea7a85a9df603843cedea88c0fa257516685490305bf9786e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "308ca66eee95d0a2351ca7b47d3adc006a1f0e613445970bce58cc04ff3d89cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec7706312166324c2985e341a85ffe488579a62e056e83fc93f4179db26cc050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31eedc705f38938c67c4808af9b2e533d37369110fa4616b461149f1319f9686"
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