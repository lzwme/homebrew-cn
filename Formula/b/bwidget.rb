class Bwidget < Formula
  desc "Tcl/Tk script-only set of megawidgets to provide the developer additional tools"
  homepage "https://core.tcl-lang.org/bwidget/home"
  url "https://downloads.sourceforge.net/project/tcllib/BWidget/1.10.1/bwidget-1.10.1.tar.gz"
  sha256 "4aea02f38cf92fa4aa44732d4ed98648df839e6537d6f0417c3fe18e1a34f880"
  license "TCL"

  livecheck do
    url "https://sourceforge.net/projects/tcllib/rss?path=/BWidget"
    regex(%r{url=.*?/bwidget[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2f6bfa229af46c7d9bb973139f09eb4c815eac04e209a3d6d20d8ef3fa82c7a4"
  end

  depends_on "tcl-tk"

  def install
    (lib/"bwidget").install Dir["*"]
  end

  test do
    # Fails with: no display name and no $DISPLAY environment variable
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    test_bwidget = <<~EOS
      puts [package require BWidget]
      exit
    EOS
    assert_equal version.to_s, pipe_output("#{Formula["tcl-tk"].bin}/tclsh", test_bwidget).chomp
  end
end