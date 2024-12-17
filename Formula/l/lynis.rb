class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https:cisofy.comlynis"
  url "https:github.comCISOfylynisarchiverefstags3.1.3.tar.gz"
  sha256 "9932147acafb1c5e13289a8bd46e8d330d4a97473da30ec04650ad019e497cd0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c8c025e5491d98e1a941e81bc8f209b9682939c3a22afd8c28490c44866ac35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c8c025e5491d98e1a941e81bc8f209b9682939c3a22afd8c28490c44866ac35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c8c025e5491d98e1a941e81bc8f209b9682939c3a22afd8c28490c44866ac35"
    sha256 cellar: :any_skip_relocation, sonoma:        "c689f3f8ac2d4a6dd40426f841d388dd93194d63c9378fef5c84498395e840dd"
    sha256 cellar: :any_skip_relocation, ventura:       "c689f3f8ac2d4a6dd40426f841d388dd93194d63c9378fef5c84498395e840dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c8c025e5491d98e1a941e81bc8f209b9682939c3a22afd8c28490c44866ac35"
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