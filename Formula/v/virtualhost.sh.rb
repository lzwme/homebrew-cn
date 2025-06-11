class VirtualhostSh < Formula
  desc "Script for macOS to create Apache virtual hosts"
  homepage "https:github.comvirtualhostvirtualhost.sh"
  url "https:github.comvirtualhostvirtualhost.sharchiverefstags1.35.tar.gz"
  sha256 "75d34b807e71acd253876c6a99cdbc11ce31ffb159155373c83a99af862fffcc"
  head "https:github.comvirtualhostvirtualhost.sh.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "caf611d27d2f3391098872acc83c015efe68d7a267e5912d423a0bfd2d3e64e3"
  end

  # Can re-enable if v2 has a stable release
  disable! date: "2024-08-13", because: :no_license

  def install
    bin.install "virtualhost.sh"
  end
end