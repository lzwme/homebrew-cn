class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://ghproxy.com/https://github.com/direnv/direnv/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "8ef18051aa6bdcd6b59f04f02acdd0b78849b8ddbdbd372d4957af7889c903ea"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "b1795e6743e0bb769f92d07aa5d2401c57b7bee715fc68894c2f5d1c95aba013"
    sha256 arm64_ventura:  "1c2d6d8b0bdc071b4344600ec914dd52f521c3d21f9fd38a6e218e65cc50fb36"
    sha256 arm64_monterey: "1e365c468da6a471f28c21ef11871641f8414d1c45b9710509884a9aa8b6fe78"
    sha256 sonoma:         "cd4b008579b836b43778c197cfa953cb3934505db0e65053ae5a9d4c10155c60"
    sha256 ventura:        "55781935916235989a46904640a4728a0a3dc24228db7cc9dbac5954b95e52dd"
    sha256 monterey:       "6b0c4abed5b230f6e3112df41f9019dd8291a5cb3c82e3337471e2b4aa5e28ea"
    sha256 x86_64_linux:   "65deffe8cb70793402e4ac64655d9805b0b84f174fe8a32dd0722d1781bc4a1f"
  end

  depends_on "go" => :build
  depends_on "bash"

  def install
    system "make", "install", "PREFIX=#{prefix}", "BASH_PATH=#{Formula["bash"].bin}/bash"
  end

  test do
    system bin/"direnv", "status"
  end
end