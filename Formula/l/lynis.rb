class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://ghfast.top/https://github.com/CISOfy/lynis/archive/refs/tags/3.1.5.tar.gz"
  sha256 "02e16e452a926b6dbae5bfc28b0592d42c8af24c572180f444ac865e0e4f4bce"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "972613fc1d39ce5f710f2a94d13e1074aceee0426d4c0ff527b9b905e4fc4075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "972613fc1d39ce5f710f2a94d13e1074aceee0426d4c0ff527b9b905e4fc4075"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "972613fc1d39ce5f710f2a94d13e1074aceee0426d4c0ff527b9b905e4fc4075"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a3d0c16f5c8466f7a8dffad024d07dab21897f795df9a42fd641497b5af1246"
    sha256 cellar: :any_skip_relocation, ventura:       "9a3d0c16f5c8466f7a8dffad024d07dab21897f795df9a42fd641497b5af1246"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "972613fc1d39ce5f710f2a94d13e1074aceee0426d4c0ff527b9b905e4fc4075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "972613fc1d39ce5f710f2a94d13e1074aceee0426d4c0ff527b9b905e4fc4075"
  end

  def install
    inreplace "lynis" do |s|
      s.gsub! 'tINCLUDE_TARGETS="/usr/local/include/lynis ' \
              '/usr/local/lynis/include /usr/share/lynis/include ./include"',
              %Q(tINCLUDE_TARGETS="#{include}")
      s.gsub! 'tPLUGIN_TARGETS="/usr/local/lynis/plugins ' \
              "/usr/local/share/lynis/plugins /usr/share/lynis/plugins " \
              '/etc/lynis/plugins ./plugins"',
              %Q(tPLUGIN_TARGETS="#{prefix}/plugins")
      s.gsub! 'tDB_TARGETS="/usr/local/share/lynis/db /usr/local/lynis/db ' \
              '/usr/share/lynis/db ./db"',
              %Q(tDB_TARGETS="#{prefix}/db")
    end
    inreplace "include/functions" do |s|
      s.gsub! 'tPROFILE_TARGETS="/usr/local/etc/lynis /etc/lynis ' \
              '/usr/local/lynis ."',
              %Q(tPROFILE_TARGETS="#{prefix}")
    end

    prefix.install "db", "include", "plugins", "default.prf"
    bin.install "lynis"
    man8.install "lynis.8"
  end

  test do
    assert_match "lynis", shell_output("#{bin}/lynis --invalid 2>&1", 64)
  end
end