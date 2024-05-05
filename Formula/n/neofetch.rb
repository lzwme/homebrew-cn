class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https:github.comdylanarapsneofetch"
  url "https:github.comdylanarapsneofetcharchiverefstags7.1.0.tar.gz"
  sha256 "58a95e6b714e41efc804eca389a223309169b2def35e57fa934482a6b47c27e7"
  license "MIT"
  head "https:github.comdylanarapsneofetch.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "78eb3e99dfde7f5fb1c3b192804a6d345f428c9effa6ea6ba54d7e5b7254387f"
  end

  deprecate! date: "2024-05-04", because: :repo_archived

  on_macos do
    depends_on "screenresolution"
  end

  def install
    inreplace "neofetch", "usrlocal", HOMEBREW_PREFIX
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end