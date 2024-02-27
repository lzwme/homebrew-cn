class FbClient < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.3.0.tar.gz"
  sha256 "1164eca06eeacb4210d462c4baf1c4004272a6197d873d61166e7793539d1983"
  license "GPL-3.0-only"
  revision 1
  head "https://git.server-speed.net/users/flo/fb", using: :git, branch: "master"

  livecheck do
    url :homepage
    regex(%r{Latest release:.*?href=.*?/fb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "7814e58c7c35286591e3b10cbaeab8fea21e654ae6b14e6f05c60125e10defce"
    sha256 cellar: :any,                 arm64_ventura:  "88df59a1ebd394d2445e19fa9f218b752c6f9d325700d77b1a2b838ffd520689"
    sha256 cellar: :any,                 arm64_monterey: "e92cc482d4fb699989e35b141a4a2851963cda5b98cf6ffef6f309f7ac6155b4"
    sha256 cellar: :any,                 sonoma:         "8e988cc9b581da5231a3ac32a56f49e224b80d67f6c671088190e63895537871"
    sha256 cellar: :any,                 ventura:        "9900708185c7fd39bc957367d20e6b08c1f321f778abfef9649c6dae0e16b489"
    sha256 cellar: :any,                 monterey:       "d640af9211e77b5e213f1b4892a1bd5879e375b4d03759b9692a09947f7d4ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6db476788ff1f3382c33618fc87f75f8c04c31d55c6fffcdcc6cfb2f53a1575"
  end

  depends_on "curl"
  depends_on "python@3.12"

  conflicts_with "spotbugs", because: "both install a `fb` binary"

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/c9/5a/e68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72/pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources

    rw_info = python_shebang_rewrite_info(libexec/"bin/python")
    rewrite_shebang rw_info, "fb"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"fb", "-h"
  end
end