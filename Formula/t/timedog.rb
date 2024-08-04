class Timedog < Formula
  desc "Lists files that were saved by a backup of the macOS Time Machine"
  homepage "https:github.comnlfiedlertimedog"
  url "https:github.comnlfiedlertimedogarchiverefstagsv1.4.tar.gz"
  sha256 "169ab408fe5c6b292a7d4adf0845c42160108fd43d6a392b95210204de49cb52"
  license "GPL-2.0"
  head "https:github.comnlfiedlertimedog.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a0e45f17640f67392a0681305ed9ea138fde831f355a79ef857d05e1fd7e0b9e"
  end

  depends_on :macos

  def install
    bin.install "timedog"
  end

  test do
    assert_match "No machine directory found for host", shell_output("#{bin}timedog 2>&1", 1)
  end
end