class Staq < Formula
  desc "Full-stack quantum processing toolkit"
  homepage "https://github.com/softwareQinc/staq"
  url "https://ghproxy.com/https://github.com/softwareQinc/staq/archive/v3.2.tar.gz"
  sha256 "c7f96d0959dcd59485786ea1137890ffedd26e17701558035926e9885093a653"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a4257c4b3d61600476f0ff51d3079d3076f0ae4e2decb59e4454c8f940b59c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd5e294d8871e7cc70e098232b2c85ca3449179432dc753f505f26eed6d46b27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30c6cb1ae200ddc0fffb3fe1d80c18a66ad575390d08175f1c5196c0382d9879"
    sha256 cellar: :any_skip_relocation, ventura:        "4b890765b97d6f37613d5cbbb12b745d3f1eafcd11f77e3f454696647a2f3553"
    sha256 cellar: :any_skip_relocation, monterey:       "d02717809252a49e5d083dbea145411bf259f19dad96b26a34e7393f1951a9f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d6796d65a0e08197b8cb695c85e6c344efc52b21658a308f8dc20a54d7af644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca60084be48ba7ff821fe3bbc653727bb91c7d08afff8d510060f9b811de4ff2"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"input.qasm").write <<~EOS
      OPENQASM 2.0;
      include "qelib1.inc";

      qreg q[1];
      creg c[1];
      h q[0];
      h q[0];
      measure q->c;
    EOS
    assert_equal <<~EOS, shell_output("#{bin}/staq -O3 ./input.qasm").chomp
      OPENQASM 2.0;
      include "qelib1.inc";

      qreg q[1];
      creg c[1];
      measure q[0] -> c[0];
    EOS
  end
end