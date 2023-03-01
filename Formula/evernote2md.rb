class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://ghproxy.com/https://github.com/wormi4ok/evernote2md/archive/v0.18.1.tar.gz"
  sha256 "7657a93c069674cdd63b5b10c3746afc27b3f100a99dfdf5c7797d6316ab5c80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af1f5c6c13bfa01afe6e3447faa275742071bb653afdb1899a7254a322ea7dbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba43bab0ec242adf2505fbb4ccfea0082aca034c96af5561cac26ddf2e449b88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21690e16bfee9f50504ec6a505fd2074fa631ff3d135732d4f65d5aed0db7014"
    sha256 cellar: :any_skip_relocation, ventura:        "134d8ff825076fa9724439dca7eb6e696da7e0f04c7e55db8462b8852e30c8f6"
    sha256 cellar: :any_skip_relocation, monterey:       "9c33acd2b7b07b21033f828f6757e3ca25bdd6ff5520cf597b76b3164a2a9830"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e17f411c69b93109d59f55c796b50c48b8a0a4757862f1a00fc37f6c1af7ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc55a34f5bbccd9033da83e939725d34278e5ed107ce905ed66ae3034b0f8a93"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath/"export.enex").write <<~EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE en-export SYSTEM "http://xml.evernote.com/pub/evernote-export3.dtd">
      <en-export>
        <note>
          <title>Test</title>
          <content>
            <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><div><br /></div></en-note>]]>
          </content>
        </note>
      </en-export>
    EOF
    system bin/"evernote2md", "export.enex"
    assert_predicate testpath/"notes/Test.md", :exist?
  end
end