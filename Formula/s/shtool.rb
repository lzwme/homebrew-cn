class Shtool < Formula
  desc "GNU's portable shell tool"
  homepage "https://www.gnu.org/software/shtool/"
  url "https://ftp.gnu.org/gnu/shtool/shtool-2.0.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/shtool/shtool-2.0.8.tar.gz"
  sha256 "1298a549416d12af239e9f4e787e6e6509210afb49d5cf28eb6ec4015046ae19"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9a07b590184786375b1faecf0b3cc9cdd24c17b88eae56888a5aa115ce3242a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dca989d435af4e89422e5d3290d90075732d2ec3daf671c95a30eba9a91aa653"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f5de9d85e4a603a10f6a5807bfe6a917d7f18360206524091d5abadbdf45e3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f5de9d85e4a603a10f6a5807bfe6a917d7f18360206524091d5abadbdf45e3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d8d8aad608219d2b3339f2b629140a52526992ca1d68e0a2a31f3764adc1237"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e4781441bddb75b099fe9b56b8b04222a18bcdd495a64828c576af7a5f865b3"
    sha256 cellar: :any_skip_relocation, ventura:        "39f3d1b2dc2807881f83ea84746b5fe4bc8c08469998d8c731da0137eb0a9461"
    sha256 cellar: :any_skip_relocation, monterey:       "39f3d1b2dc2807881f83ea84746b5fe4bc8c08469998d8c731da0137eb0a9461"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b414c1d021d5c209412a8162722017490d3566176272e00340a249ba06adf4e"
    sha256 cellar: :any_skip_relocation, catalina:       "e2f7c7a3b0b39b0b9d161e503310b09443cc8e4dc5283dce371afa0b4d87094a"
    sha256 cellar: :any_skip_relocation, mojave:         "7d9087a21cd6724aa82694ceca768d3044d5ab854c5ba95ae04146b3b83c2bf5"
    sha256 cellar: :any_skip_relocation, high_sierra:    "fc22505f6424dece01dcdee55907eebcb490a299763f2f217511fa14c5927711"
    sha256 cellar: :any_skip_relocation, sierra:         "172a4e2c133efcc6235aa3901bbc89ea11c48cfa70833fe67801240236d1757d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "17dcf1289dd178b75b670d8061d54e4b2004feeb7de0d9e1ea43ffb46220e4fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b28df54f6be434a134aea29f860a21ee228603c047e091efed4a90a87b83ff13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08f697c85512b71c0e002ce1db265280f5ddf766de012e80f82701e1e0272879"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/shtool echo 'Hello World!'").chomp
  end
end