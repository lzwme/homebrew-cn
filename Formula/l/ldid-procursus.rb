class LdidProcursus < Formula
  desc "Put real or fake signatures in a Mach-O binary"
  homepage "https://github.com/ProcursusTeam/ldid"
  url "https://github.com/ProcursusTeam/ldid.git",
     tag:      "v2.1.5-procursus7",
     revision: "aaf8f23d7975ecdb8e77e3a8f22253e0a2352cef"
  version "2.1.5-procursus7"
  license "AGPL-3.0-or-later"
  revision 1
  head "https://github.com/ProcursusTeam/ldid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ce834166720b5788636ce9dfeb2b446be1a454515abde1941187d219282def09"
    sha256 cellar: :any,                 arm64_monterey: "93e84ff2e1e2da2b857b52f275128d97681cfe41e9f59f2f3222f378ef35fa37"
    sha256 cellar: :any,                 arm64_big_sur:  "4a685ad1062cc656373edfe43548bf7adbf5c3dead465cc86d0739dac006df01"
    sha256 cellar: :any,                 ventura:        "f3745355487cf17375f645f31cf34e85bde0bbb4960e75885c6106196a265589"
    sha256 cellar: :any,                 monterey:       "21262358f8d2a81af29c475ace106bf65a970a85c69f391386b9f9fdfe8106b3"
    sha256 cellar: :any,                 big_sur:        "ff338dfc081e8ed4930aecbfb55629ed21cc4a34bf9f346ca987e01ea5c48cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "652b8cca448c7047a641d795a7149bff84a282bf8727c72ec6a83a05619fd2ac"
  end

  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "openssl@3"

  conflicts_with "ldid", because: "ldid installs a conflicting ldid binary"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    zsh_completion.install "_ldid"
  end

  test do
    cp test_fixtures("mach/a.out"), testpath
    system bin/"ldid", "-S", "a.out"
  end
end