class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:github.comrbenvruby-build"
  url "https:github.comrbenvruby-buildarchiverefstagsv20240709.1.tar.gz"
  sha256 "b1a35279c0c1b6eb308cb607d90b470b7b89f04372c512aec38bc934e109faeb"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d1c74af0fbfdcf4b3dec26f03ed4a346800f703cf264cac80630021a15942e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d1c74af0fbfdcf4b3dec26f03ed4a346800f703cf264cac80630021a15942e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d1c74af0fbfdcf4b3dec26f03ed4a346800f703cf264cac80630021a15942e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d1c74af0fbfdcf4b3dec26f03ed4a346800f703cf264cac80630021a15942e3"
    sha256 cellar: :any_skip_relocation, ventura:        "8d1c74af0fbfdcf4b3dec26f03ed4a346800f703cf264cac80630021a15942e3"
    sha256 cellar: :any_skip_relocation, monterey:       "8d1c74af0fbfdcf4b3dec26f03ed4a346800f703cf264cac80630021a15942e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "000781df2b407ed286b9ffa261fec271d4da181f4b86153b766346e2a2a2631a"
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