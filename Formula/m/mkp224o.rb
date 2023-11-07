class Mkp224o < Formula
  desc "Vanity address generator for tor onion v3 (ed25519) hidden services"
  homepage "https://github.com/cathugger/mkp224o"
  url "https://ghproxy.com/https://github.com/cathugger/mkp224o/releases/download/v1.6.1/mkp224o-1.6.1-src.tar.gz"
  sha256 "772d4b429c08f04eca3bc45cd3f6ce57b71fa912fa6c061cd39f73bf2fec8e70"
  license "CC0-1.0"
  revision 1
  head "https://github.com/cathugger/mkp224o.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "61283aa2acafa66ffabc064e62d7ce68283b72e82ea756e66325280bf4b77602"
    sha256 cellar: :any,                 arm64_ventura:  "56bc588afbe1543a383982b6bd745cf441a5e5f6562a9cb8ea84fbb5b7f9d531"
    sha256 cellar: :any,                 arm64_monterey: "961a0ec2a23a7f0b2d7ade5515cd91ada5c2f97fab8e58227331cfbd6813292a"
    sha256 cellar: :any,                 sonoma:         "af9a18e9169dd69f4ade7f99df10e2dd2e04d09b6d66b2cd43b61d823085b29f"
    sha256 cellar: :any,                 ventura:        "1d73166eafa6fe93119ed962fcd34a4741315cddc61b13a88071ce3ec33cbe34"
    sha256 cellar: :any,                 monterey:       "f79051333f166545cf8d6a3b29b93a2543ba42466845f5f26db28391c42aad8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f7a759233a2d61e95ce7d5a99a895e3afac07362d8f4b650f85ccbda4f6f65b"
  end

  depends_on "libsodium"

  def install
    system "./configure", *std_configure_args
    system "make"
    bin.install "mkp224o"
  end

  test do
    assert_match "waiting for threads to finish...", shell_output("#{bin}/mkp224o -n 3 home 2>&1")
  end
end