class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https:sdns.dev"
  url "https:github.comsemihalevsdnsarchiverefstagsv1.5.2.tar.gz"
  sha256 "52d75a4d4e4c09982e7b1f66e93cdd3eadc57a6c3112f84ede7cd94b902ad19c"
  license "MIT"
  head "https:github.comsemihalevsdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4064e44c2a1a85d75b5f14b9b73cca90ddae74e71603c739ceedd13f382c546c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77984cb1b823d23f0f3d6520d9966e480da483d4757fb4099cec19a04feef0ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c99084bd16ab5af032af3c772738057d75826b0b7c9b2003d46e861e87e88021"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4cda2d0f8c878e05f6f325b277df2d39acd884258153e397b3a8d1ff0299b0a"
    sha256 cellar: :any_skip_relocation, ventura:       "99f5feddd9eb110578e38eeb70fa8ce4402534cef244a154182b1971b43f6d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6127f64d913ece10acf827cab12db488e6069bc0b28baa0583c4b94bc9863183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a20163180f6650265add0d6c5c5805f1547516f823bd7c0499d4505d11690fd8"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin"sdns", "--config", etc"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var"logsdns.log"
    log_path var"logsdns.log"
    working_dir opt_prefix
  end

  test do
    spawn bin"sdns", "--config", testpath"sdns.conf"
    sleep 2
    assert_path_exists testpath"sdns.conf"
  end
end