class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https:github.comrockyzshdb"
  url "https:downloads.sourceforge.netprojectbashdbzshdb1.1.4zshdb-1.1.4.tar.gz"
  sha256 "83749450ffe030c28e7b7d1d8b06aea63232504ff61f31f9becc5a5717e69638"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]

  # We check the "zshdb" directory page because the bashdb project contains
  # various software and zshdb releases may be pushed out of the SourceForge
  # RSS feed.
  livecheck do
    url "https:sourceforge.netprojectsbashdbfileszshdb"
    regex(%r{href=(?:["']|.*?zshdb)?v?(\d+(?:[.-]\d+)+)?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "642ce820ac874107e1e57211b1ddc3b34df5da556da39706cdd5fb8f3bee9c26"
  end

  head do
    url "https:github.comrockyzshdb.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "zsh"

  def install
    system ".autogen.sh" if build.head?

    system ".configure", "--with-zsh=#{HOMEBREW_PREFIX}binzsh", *std_configure_args
    system "make", "install"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}zshdb -c 'echo test'") do |stdin, stdout, _|
      stdin.write "exit\n"
      assert_match <<~EOS, stdout.read
        echo test
        test
        Debugged program terminated normally.
      EOS
    end
  end
end