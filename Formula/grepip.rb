class Grepip < Formula
  desc "Filters IPv4 & IPv6 addresses with a grep-compatible interface"
  homepage "https://ipinfo.io"
  url "https://ghproxy.com/https://github.com/ipinfo/cli/archive/grepip-1.2.2.tar.gz"
  sha256 "2ed9477bc5599a10348a7026968242fb4609e6b580c04aaae46d7c71b9fa3d55"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^grepip[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "127a16e5a544dfd437b203f471b8259cf247c655cbc1031689998280d5a4054c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "127a16e5a544dfd437b203f471b8259cf247c655cbc1031689998280d5a4054c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "127a16e5a544dfd437b203f471b8259cf247c655cbc1031689998280d5a4054c"
    sha256 cellar: :any_skip_relocation, ventura:        "1368886025366798bc84ccf0dece8def4aeec415fa2dad37a9cdc675b09b8526"
    sha256 cellar: :any_skip_relocation, monterey:       "1368886025366798bc84ccf0dece8def4aeec415fa2dad37a9cdc675b09b8526"
    sha256 cellar: :any_skip_relocation, big_sur:        "1368886025366798bc84ccf0dece8def4aeec415fa2dad37a9cdc675b09b8526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d066156f98edcbf0164a1ee749cba4e78b14dc6cb4a39b3be80b9484aa6a61ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./grepip"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/grepip --version").chomp
    assert_equal "1.1.1.1", pipe_output("#{bin}/grepip -o", "asdf 1.1.1.1 asdf").chomp

    (testpath/"access.log").write <<~EOS
      127.0.0.1 valid ip but reserved
      111.119.187.44 valid ip
      8.8.8. invalid ip
      no ip
    EOS
    output = shell_output("#{bin}/grepip --exclude-reserved -h access.log")
    assert_equal "111.119.187.44 valid ip", output.strip
  end
end