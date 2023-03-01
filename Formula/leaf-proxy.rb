class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://ghproxy.com/https://github.com/eycorsican/leaf/archive/v0.7.1.tar.gz"
  sha256 "6aed2e706ee5e1d631766288d5c7b0211f00a0892670b505fdea944834a64162"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d2dd7de79776e366a53205aebcb29806940378e412ed78b54eb50f0aa624b2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b3f65699188da95822fb153df654ea5852891c514b253d3c2e5ee6b06d0a844"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0f39886f5e0be05e474b9b3c3a740df46f628436727661d8ae3bd75b2132e7e"
    sha256 cellar: :any_skip_relocation, ventura:        "5b4207907e13838b2169ad48825043fc9e270f2888ea2a1b81091000acca9294"
    sha256 cellar: :any_skip_relocation, monterey:       "3099439f2f42d81dd5eb73dd97a4a78d078749e96862e466445a3d964324fc89"
    sha256 cellar: :any_skip_relocation, big_sur:        "d517413963583e6a97512e7ebc454a6a52c941ef98a5ec66f15d3d9d1ce10758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6a6f45af7c9848ae84b3162dbdbc64b5189358628d8ed17e706e8c11035efe6"
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