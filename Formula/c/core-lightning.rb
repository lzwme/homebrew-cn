class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://ghproxy.com/https://github.com/ElementsProject/lightning/releases/download/v23.11/clightning-v23.11.zip"
  sha256 "86bfe7e898fb0c2c3b5e87e2d72f4a2a7df542f368672be966997288d3a337e0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d955243c7f6cfa33740ed28cabf75b852c2aa1bb990884e4007c7a4737c090a"
    sha256 cellar: :any,                 arm64_ventura:  "5f0a72ace33cc3a04f63c2d5666ba8a2d2e5b163d3d9b94b7aae1b590c23cc99"
    sha256 cellar: :any,                 arm64_monterey: "cd8783a1bf41c4b25a0586a88376c087babb54890dcdfee0c04dc4f0cb0707c9"
    sha256 cellar: :any,                 sonoma:         "959c728c8a639fcab5883e227154456d9f709d07a779547b916dc5051411a2b3"
    sha256 cellar: :any,                 ventura:        "e6ca136bc50e82d931689c883c21a145666f62e3999a5a83f70db95779f0d9ed"
    sha256 cellar: :any,                 monterey:       "7018269e49332278932bbc504d0b5a10c097f7c185f8a20f83e8608b2f618eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebad87389526ff2c82fc5b71ba411788226407d171f82100a21e41772ae9e004"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkg-config" => :build
  depends_on "poetry" => :build
  depends_on "protobuf" => :build

  depends_on "bitcoin"
  depends_on "gmp"
  depends_on "libsodium"
  depends_on "python@3.11"
  uses_from_macos "sqlite"

  def install
    (buildpath/"external/lowdown").rmtree
    system "poetry", "env", "use", "3.11"
    system "poetry", "install", "--only=main"
    system "./configure", "--prefix=#{prefix}"
    system "poetry", "run", "make", "install"
  end

  test do
    cmd = "#{bin}/lightningd --daemon --network regtest --log-file lightningd.log"
    if OS.mac? && Hardware::CPU.arm?
      lightningd_output = shell_output("#{cmd} 2>&1", 10)
      assert_match "lightningd: Could not run /lightning_channeld: No such file or directory", lightningd_output
    else
      lightningd_output = shell_output("#{cmd} 2>&1", 1)
      assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output
    end

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end