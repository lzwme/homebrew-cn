class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://ghproxy.com/https://github.com/eycorsican/leaf/archive/v0.10.6.tar.gz"
  sha256 "4355de35e5019e6a909cffca1bfe283cec0aa95f6c8b220523115760b2ebe08f"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c88193280098e1b136fd2ed1face824b4135064a9e8048d9006c9db6e3c20e54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4a6e75137f53e33211662838cc2b837323ac5e9cc28009eb8e1f2d6c786de18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42e76bdadaf79a73627a659ffa491b86c06dc3ec547f35f5a973a205eaedbb9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc8919afc77ffd8410329ed8874ea96771f84104a20a6dfbd5c321b46de5cdb9"
    sha256 cellar: :any_skip_relocation, ventura:        "c857340520c665c6e13c8c09653c4eabd3ca0fdfa96fdc8205820be35e2dda4b"
    sha256 cellar: :any_skip_relocation, monterey:       "fdeb7f69ce1f4fd91a4b363627e9b2881ddccfed39d76bfa669681769e284f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b2c03d495391c6c29f38be330d9e515efca0b4b39a988a63141faeda410d19b"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    cd "leaf-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}/leaf -c #{testpath}/config.conf -t SS"

    assert_match "TCP failed: all attempts failed", output
  end
end