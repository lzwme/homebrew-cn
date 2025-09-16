class Stm32flash < Formula
  desc "Open source flash program for STM32 using the ST serial bootloader"
  homepage "https://sourceforge.net/projects/stm32flash/"
  url "https://downloads.sourceforge.net/project/stm32flash/stm32flash-0.7.tar.gz"
  sha256 "c4c9cd8bec79da63b111d15713ef5cc2cd947deca411d35d6e3065e227dc414a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/stm32flash[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f8e474cef1409121473bd9d5faaee88d9a164949b2b6f3bba17dff7a20875383"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b888c0246ff2ed980cc2ca7e08e8890641bec73f22a47dea03dad402dfaff6e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b07e1d419f8b53f22dbd8479b61446e99cf2f9fcad620af12ab8cbcce21d27f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "069b91e908bd359fa0e012376d4eb6718c4ac734319ba06d6dd4e74359528a96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38b8fa0ed69728d5241842266710e1a788e50bd1ceab7fa2a01606dbb62cf887"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8d0be7957abf2048e99a1fea198a207be5edbd7ccdb402b8bfe650575ac64ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "953034cea97ccfa773a277c96d39f008ab73849a7d709feb453b6fc990955407"
    sha256 cellar: :any_skip_relocation, ventura:        "10f5d11bf70e2d5f4b7bcc15468c698d90bf3fef80f7a9242aa0590d69fead89"
    sha256 cellar: :any_skip_relocation, monterey:       "eb2bcf9748b22a6d1809d675ad765345f0f539d0dbf49449d0977618e4e7f019"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3a9d072fce40d5fd3af1f86019966abf4d4a711b26ad8539ec382aa6dfc5848"
    sha256 cellar: :any_skip_relocation, catalina:       "8e76969a80aef9a483e6ad09064f1b7d08e2d5e02829c12d2dc0e9a31256f9a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2c3d8911cbf5af6047635b5c494c369f587fe8b8a904a88e3b8fd9e0a2e897d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b63e10544099db4a148fefe54fe036746f96ab2e1d637e73702ae458cb442f93"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/stm32flash -k /dev/tty.XYZ 2>&1", 1)
    assert_match "Failed to open port: /dev/tty.XYZ", output
  end
end