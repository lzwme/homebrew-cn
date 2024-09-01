class Packetq < Formula
  desc "SQL-like frontend to PCAP files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.7.2.tar.gz"
  sha256 "07448d59315f6dfb50408c3c922bdc11bf590db639da15c041330bf21f15a6f8"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06a09654a38aecc2a9a949e343108225d89d3e71e94b4bc355c81b1dd9302bb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2442e115398e3b589059032df51202f329391cc623d5855e5030efbffa69ba2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51fe21d5b07ea5cb17163ef8bc1265d0b549464fcecb9e1f4d2b14e86012edee"
    sha256 cellar: :any_skip_relocation, sonoma:         "76cedb5518e6b28b12cab51584fda888b6654bed5c85531d084579017ef547b0"
    sha256 cellar: :any_skip_relocation, ventura:        "292a29bca2d46d7fd6c9cb6bc54a8a7b9be0035c8481e3a03c8243901e464f69"
    sha256 cellar: :any_skip_relocation, monterey:       "69d252d932bdaef0814b954ac0125687a3311fa0b62a2a8d0b44ced4ca17ace1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da2b991883f398c2cd94dedd9c5e3a0fcd15cc6bf75668d391c2f64aae7e063"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/packetq --csv -s 'select id from dns' -")
    assert_equal '"id"', output.chomp
  end
end