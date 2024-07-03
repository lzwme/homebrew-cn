class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:github.comrbenvruby-build"
  url "https:github.comrbenvruby-buildarchiverefstagsv20240702.tar.gz"
  sha256 "21b34a653ddbe29a4a5f3e9f71d3a634816295a549569899c6d1148a821b2273"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93e7aa582c489a6161e60b90ba1b0d2ee427f94df0ea1ea00acfb711646ec3cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93e7aa582c489a6161e60b90ba1b0d2ee427f94df0ea1ea00acfb711646ec3cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e7aa582c489a6161e60b90ba1b0d2ee427f94df0ea1ea00acfb711646ec3cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "93e7aa582c489a6161e60b90ba1b0d2ee427f94df0ea1ea00acfb711646ec3cf"
    sha256 cellar: :any_skip_relocation, ventura:        "93e7aa582c489a6161e60b90ba1b0d2ee427f94df0ea1ea00acfb711646ec3cf"
    sha256 cellar: :any_skip_relocation, monterey:       "93e7aa582c489a6161e60b90ba1b0d2ee427f94df0ea1ea00acfb711646ec3cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f08566bd16d5f1aca4df9f1492da949964d970f43361589487f058ffa5717f47"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    # these references are (as-of v20210420) only relevant on FreeBSD but they
    # prevent having identical bottles between platforms so let's fix that.
    inreplace "binruby-build", "usrlocal", HOMEBREW_PREFIX

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}ruby-build --definitions")
  end
end