class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:github.comrbenvruby-build"
  url "https:github.comrbenvruby-buildarchiverefstagsv20240517.tar.gz"
  sha256 "6b4c5cc35f1049adcfb8ef3812d26df4529552cd818a58a749c98165cd7055f0"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c5f5252634946bae30b768ee7944592baa354a2919d42f5c0061b4284c9319c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cadc3e7efdd2d9ec389f41fcba047211be7dd7164d7c9890ed3c6f91c08a30b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26c0bdc657456af739add5d0176c0ea2cc1f5be198ff2a0bd421b72982e8a2fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3151f89ab48a3b4763aaa8cf6ac1d8ebc78a78292c2fa0ca975f47d66d09d1a0"
    sha256 cellar: :any_skip_relocation, ventura:        "d17b347f6af542721923a684ca0407386e967129ae9ece54db963bfedb1b6e25"
    sha256 cellar: :any_skip_relocation, monterey:       "f2e22c985b2837f1955b645746676abea5288f8545126789871976e4e2ef5daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "791a85236f22a673e77aeba35d60e73c8a1f6f166b5795aca91623d38c352795"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "pkg-config"
  depends_on "readline"
  on_macos do
    depends_on "openssl@3"
  end

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