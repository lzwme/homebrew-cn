class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:github.comrbenvruby-build"
  url "https:github.comrbenvruby-buildarchiverefstagsv20240722.tar.gz"
  sha256 "e20be01cab3bafa924f33096e9ce9ed56ffeab47f6656d81049c2702114e9b55"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "364cb83f4e14a82d27f8acef907c7409c6e25c40d13fc5ac753e2279d4e7ea6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "364cb83f4e14a82d27f8acef907c7409c6e25c40d13fc5ac753e2279d4e7ea6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "364cb83f4e14a82d27f8acef907c7409c6e25c40d13fc5ac753e2279d4e7ea6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "364cb83f4e14a82d27f8acef907c7409c6e25c40d13fc5ac753e2279d4e7ea6b"
    sha256 cellar: :any_skip_relocation, ventura:        "364cb83f4e14a82d27f8acef907c7409c6e25c40d13fc5ac753e2279d4e7ea6b"
    sha256 cellar: :any_skip_relocation, monterey:       "364cb83f4e14a82d27f8acef907c7409c6e25c40d13fc5ac753e2279d4e7ea6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa85503fe8e6bf917d7163337ff88b15e283d0c461337c6b4ed43b3188dad87d"
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