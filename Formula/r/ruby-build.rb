class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:github.comrbenvruby-build"
  url "https:github.comrbenvruby-buildarchiverefstagsv20240517.tar.gz"
  sha256 "6b4c5cc35f1049adcfb8ef3812d26df4529552cd818a58a749c98165cd7055f0"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "409649a4f392be249a31788be094ea6e1d06d8ad36fe11c416ce7235aadbb8d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "409649a4f392be249a31788be094ea6e1d06d8ad36fe11c416ce7235aadbb8d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "409649a4f392be249a31788be094ea6e1d06d8ad36fe11c416ce7235aadbb8d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "409649a4f392be249a31788be094ea6e1d06d8ad36fe11c416ce7235aadbb8d4"
    sha256 cellar: :any_skip_relocation, ventura:        "409649a4f392be249a31788be094ea6e1d06d8ad36fe11c416ce7235aadbb8d4"
    sha256 cellar: :any_skip_relocation, monterey:       "409649a4f392be249a31788be094ea6e1d06d8ad36fe11c416ce7235aadbb8d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d3335fa73aba26a7d3a51d8ee02be9391e2ba39a6e01ad60ad74f6d539ed72"
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