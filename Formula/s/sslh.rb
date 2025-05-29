class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https:www.rutschle.nettechsslh.shtml"
  url "https:www.rutschle.nettechsslhsslh-v2.2.4.tar.gz"
  sha256 "696edac467111d0c1353a4ff32ed8dfa33bc914036644c69a7b9506b7ee49115"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https:github.comyrutschlesslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b4bea43abc8cb06c794eab8b50340c0362c2662f296511080d25845f69293faf"
    sha256 cellar: :any,                 arm64_sonoma:  "a79324fbee9626d381e5dab7d4ead836ced20298905976d724025d1a8d0415a0"
    sha256 cellar: :any,                 arm64_ventura: "4faad8f00274c1ed32cb9c51c739b0b3818dba0473f7a01a7ede79e0a1e30c92"
    sha256 cellar: :any,                 sonoma:        "034d8cc078f920c1d17309cfa139a56907566b036c8e822c3cecaa5c26662024"
    sha256 cellar: :any,                 ventura:       "497c715950f617bba777b9583679384d3dae2b7df9c2d54dfa32a6f60b541fce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b20ee56e1713cc9ab280630ea76598c90ce1ded6b2339b0b575012bc6b51478a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcbc728fae44f99545d0d0ed046cf5a4d79dab9f3551524bfdbfb0030118a573"
  end

  depends_on "libconfig"
  depends_on "libev"
  depends_on "pcre2"

  def install
    system ".configure", *std_configure_args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    listen_port = free_port
    target_port = free_port
    pid = spawn sbin"sslh", "--http=localhost:#{target_port}", "--listen=localhost:#{listen_port}", "--foreground"

    fork do
      TCPServer.open(target_port) do |server|
        session = server.accept
        session.write "HTTP1.1 200 OK\r\n\r\nHello world!"
        session.close
      end
    end

    sleep 1
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_equal "Hello world!", shell_output("curl -s http:localhost:#{listen_port}")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end