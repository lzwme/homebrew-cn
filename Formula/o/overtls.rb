class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.26.tar.gz"
  sha256 "3ffcdad396848559ac8f300c0d66d7f07713b1c200602943267ce18ced62fb34"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38afbfc0be44965f5b504590bb22f4f91f4d7d094438b211545985a989eecd6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0303bdb66ef8a1956002ef4492dff997db2c098e31b7dab031a1a3084f5e435a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffadf42e44ead8c0464e8448720ab9f9f6416c800e198ce47f370795070b5d1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a576eeb604a7f0c63e17b34915b74e298a52ba1817583c389f5c226756229cc"
    sha256 cellar: :any_skip_relocation, ventura:        "5747e3c74fb945af87794521ded6345938d23601ec53eaaa189e849dd28de6f1"
    sha256 cellar: :any_skip_relocation, monterey:       "85e365c83bf1dac3d976d93d3f61e839eec1475921c0c0703a00d6f68c0fdd35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cf36aebc39646a06cce033f3669de29395f429e95fa224d283404189989d435"
  end

  depends_on "rust" => :build

  # version patch, upstream pr ref, https:github.comShadowsocksR-Liveovertlspull57
  patch do
    url "https:github.comShadowsocksR-Liveovertlscommit33db5c7b33b0884f92b559f21b566de0751bf701.patch?full_index=1"
    sha256 "710c30129d490cccb65ebc9023dada0e0072b0e07b3e26686cd3f80ce14e4180"
  end

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}overtls -V")

    output = shell_output(bin"overtls -r client -c #{pkgshare}config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end