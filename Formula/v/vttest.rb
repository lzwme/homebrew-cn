class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20241031.tgz", using: :homebrew_curl
  sha256 "11c9dd187d9ee53dfe9ebe4bc9e472928c3f3926328f266953b7178c0ad5b4f2"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ec238e8f75457525647ef8b756af38d417bce60e6c89290cbedcac3d6f936e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e22018c2a7b1180923a963fb25ea4f7dc42ec5467921aae74b9769d7a4886ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "656fd61f21d899322975ef94e0880c44186308476c8d54f02ac1b19c310788d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "030bb430d0f4dd139415ef5de9c28142975f85b686511c121efcb7fbf50a9e76"
    sha256 cellar: :any_skip_relocation, ventura:       "286ad98696e7d0f8293696327c6b6a4cf4a06217a68cc2f52babb024bdd6efa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a322a1537189d0c57ec7c02c9b7f284a452c79f71cfcca31d89f405ae45b4c1e"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end