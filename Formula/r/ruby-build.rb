class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:github.comrbenvruby-build"
  url "https:github.comrbenvruby-buildarchiverefstagsv20240530.1.tar.gz"
  sha256 "60d7407038ce0c21e15d3c215eb52ed01b947f07bd78926dd79a9439c2016209"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0a53ee441765fc1dfcb410e511713f8fb40cb428103eea1c410eade24c78455"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a53ee441765fc1dfcb410e511713f8fb40cb428103eea1c410eade24c78455"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0a53ee441765fc1dfcb410e511713f8fb40cb428103eea1c410eade24c78455"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0a53ee441765fc1dfcb410e511713f8fb40cb428103eea1c410eade24c78455"
    sha256 cellar: :any_skip_relocation, ventura:        "c0a53ee441765fc1dfcb410e511713f8fb40cb428103eea1c410eade24c78455"
    sha256 cellar: :any_skip_relocation, monterey:       "c0a53ee441765fc1dfcb410e511713f8fb40cb428103eea1c410eade24c78455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dad24cb00a04d23d09978148e5dd7c2285c98a1a772e91c646606d27f74032a"
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