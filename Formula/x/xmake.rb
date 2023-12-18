class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https:xmake.io"
  url "https:github.comxmake-ioxmakereleasesdownloadv2.8.5xmake-v2.8.5.tar.gz"
  sha256 "19c67be3bcfcbda96ca87a18effac39bfccc443fbb3754c7bbc01511decd24af"
  license "Apache-2.0"
  head "https:github.comxmake-ioxmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d2dbdf8160e3faa6968e49152b73ba091e41d88836199f2caeea6df570b634a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b473853f4bcd1907520c0fce036ad1a3babe2f282c3637c6e3bafb9d0f5bddc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "915259effbce9d10145828845d68b3b96e1dbd7d85f20e667baf5af76be4ca44"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd497a94a971439311c55163bd9c0b07af6a640176f78f7bd2e3a28c89e3fec5"
    sha256 cellar: :any_skip_relocation, ventura:        "ac810f686802f182c77c175cae903733095ce0ed99337d18ff418b74e1fb3069"
    sha256 cellar: :any_skip_relocation, monterey:       "4a07ce6c1bb5b0ba741fc38f14a5195f5ec2bdef50c6f82f2c7296e6d06adb8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21cd013a67bf852fd1f3f6e66349e1454d30a9d180dbfeb6ad0e3aa1711fa420"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system ".configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV.delete "CPATH"
    system bin"xmake", "create", "test"
    cd "test" do
      system bin"xmake"
      assert_equal "hello world!", shell_output("#{bin}xmake run").chomp
    end
  end
end