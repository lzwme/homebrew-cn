class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://ghproxy.com/https://github.com/smxi/inxi/archive/3.3.28-1.tar.gz"
  sha256 "937acf2bc0a1f0890c91cf4d9c7b9d496f009e43f3621fd2b60a30345ff80a14"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "968968e7e5de9529c12c8a0e121bebd9d704d2c6485844788cb31ac19ef8d4e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "968968e7e5de9529c12c8a0e121bebd9d704d2c6485844788cb31ac19ef8d4e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "968968e7e5de9529c12c8a0e121bebd9d704d2c6485844788cb31ac19ef8d4e2"
    sha256 cellar: :any_skip_relocation, ventura:        "93d02247fed96e63f349038450e6cf5bb9fa7d977195e2e996a7cc8737ecf8f4"
    sha256 cellar: :any_skip_relocation, monterey:       "93d02247fed96e63f349038450e6cf5bb9fa7d977195e2e996a7cc8737ecf8f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "93d02247fed96e63f349038450e6cf5bb9fa7d977195e2e996a7cc8737ecf8f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "968968e7e5de9529c12c8a0e121bebd9d704d2c6485844788cb31ac19ef8d4e2"
  end

  uses_from_macos "perl"

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")
    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end