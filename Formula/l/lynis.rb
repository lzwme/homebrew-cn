class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https:cisofy.comlynis"
  url "https:github.comCISOfylynisarchiverefstags3.1.0.tar.gz"
  sha256 "bc197423b5767d42e8ae5fabc9eb40c494af9ff1543d3679cbfb97a3ba72f20e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa42ff07a71b7ea74838c20577e452385f94dd7dbb8d1ef4da05c6f93cc63d28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa42ff07a71b7ea74838c20577e452385f94dd7dbb8d1ef4da05c6f93cc63d28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa42ff07a71b7ea74838c20577e452385f94dd7dbb8d1ef4da05c6f93cc63d28"
    sha256 cellar: :any_skip_relocation, sonoma:         "6903141a385b893e605a512e2d9f2b3490fa3d89eedef375a1271cd72ce60142"
    sha256 cellar: :any_skip_relocation, ventura:        "6903141a385b893e605a512e2d9f2b3490fa3d89eedef375a1271cd72ce60142"
    sha256 cellar: :any_skip_relocation, monterey:       "6903141a385b893e605a512e2d9f2b3490fa3d89eedef375a1271cd72ce60142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa42ff07a71b7ea74838c20577e452385f94dd7dbb8d1ef4da05c6f93cc63d28"
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