class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https:cisofy.comlynis"
  url "https:github.comCISOfylynisarchiverefstags3.1.1.tar.gz"
  sha256 "ca38a27c9c92e78877be4ecffce25f3345a1d24bbcd68be66a3a600e2ff748d1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f4d6a5a942866233920ba41e72d7b74521e7b6a86932080168f54b284e5db658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7a6bd2da4ca0d667474e50b56aea971b8f8005cc1671783b066670c0a51622a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7a6bd2da4ca0d667474e50b56aea971b8f8005cc1671783b066670c0a51622a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7a6bd2da4ca0d667474e50b56aea971b8f8005cc1671783b066670c0a51622a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9c8022b97c3540b39b3d305a597999600fe0a9f95fda0228c476c0276ee26da"
    sha256 cellar: :any_skip_relocation, ventura:        "b9c8022b97c3540b39b3d305a597999600fe0a9f95fda0228c476c0276ee26da"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c8022b97c3540b39b3d305a597999600fe0a9f95fda0228c476c0276ee26da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7a6bd2da4ca0d667474e50b56aea971b8f8005cc1671783b066670c0a51622a"
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