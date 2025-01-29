class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https:cisofy.comlynis"
  url "https:github.comCISOfylynisarchiverefstags3.1.4.tar.gz"
  sha256 "db00e26cfb1e04ca70af48d106c3e2968eb468adbef17a2ab18b0028a3d1e3b7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "448e2184da51869bdca5a42fec0e7852206a7fad0d80aa787dc4041576c571cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "448e2184da51869bdca5a42fec0e7852206a7fad0d80aa787dc4041576c571cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "448e2184da51869bdca5a42fec0e7852206a7fad0d80aa787dc4041576c571cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c0cbf50ffba77355d533005be8ba0facafe499df94991533979643431ed8028"
    sha256 cellar: :any_skip_relocation, ventura:       "4c0cbf50ffba77355d533005be8ba0facafe499df94991533979643431ed8028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "448e2184da51869bdca5a42fec0e7852206a7fad0d80aa787dc4041576c571cc"
  end

  def install
    inreplace "lynis" do |s|
      s.gsub! 'tINCLUDE_TARGETS="usrlocalincludelynis ' \
              'usrlocallynisinclude usrsharelynisinclude .include"',
              %Q(tINCLUDE_TARGETS="#{include}")
      s.gsub! 'tPLUGIN_TARGETS="usrlocallynisplugins ' \
              "usrlocalsharelynisplugins usrsharelynisplugins " \
              'etclynisplugins .plugins"',
              %Q(tPLUGIN_TARGETS="#{prefix}plugins")
      s.gsub! 'tDB_TARGETS="usrlocalsharelynisdb usrlocallynisdb ' \
              'usrsharelynisdb .db"',
              %Q(tDB_TARGETS="#{prefix}db")
    end
    inreplace "includefunctions" do |s|
      s.gsub! 'tPROFILE_TARGETS="usrlocaletclynis etclynis ' \
              'usrlocallynis ."',
              %Q(tPROFILE_TARGETS="#{prefix}")
    end

    prefix.install "db", "include", "plugins", "default.prf"
    bin.install "lynis"
    man8.install "lynis.8"
  end

  test do
    assert_match "lynis", shell_output("#{bin}lynis --invalid 2>&1", 64)
  end
end