class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https:cisofy.comlynis"
  url "https:github.comCISOfylynisarchiverefstags3.1.2.tar.gz"
  sha256 "b0ed01d30a4415beb78acc47867f8e0779c9966d4febc5f4a31594ba2a0bd44d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b26eba32da66cef4c85819f95cfece20b4472fa05087b8735704764dd2fd1a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b26eba32da66cef4c85819f95cfece20b4472fa05087b8735704764dd2fd1a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b26eba32da66cef4c85819f95cfece20b4472fa05087b8735704764dd2fd1a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0828d46f43ade64b6b4ebbaa6bac1d3f4b6f01f9648b004bda56f985ef1ed4e1"
    sha256 cellar: :any_skip_relocation, ventura:       "0828d46f43ade64b6b4ebbaa6bac1d3f4b6f01f9648b004bda56f985ef1ed4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b26eba32da66cef4c85819f95cfece20b4472fa05087b8735704764dd2fd1a3"
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