class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://ghfast.top/https://github.com/fastly/pushpin/releases/download/v1.41.0/pushpin-1.41.0.tar.bz2"
  sha256 "1ceef0b8da5229a066906797e47795905f1fe8fb1477edc9d5799720df9943ef"
  license "Apache-2.0"
  head "https://github.com/fastly/pushpin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6e73465fe08f48d016e09eb9c16c6a530ffe64e30182ab4a5633ceb825b0a49c"
    sha256 cellar: :any,                 arm64_sequoia: "bbf50845458b12667c07b7372591c597d2e9700000dc8a450952828d7502640d"
    sha256 cellar: :any,                 arm64_sonoma:  "9f842c91529a5eae529bc5ccf2a6ffd2e395ae10ae39678b9f73d4308fe301c1"
    sha256 cellar: :any,                 sonoma:        "854aaf2d9faf110d01d4981893f6943e8f19902d46b27071d9024c1337fc4f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5adc9058a2d49d129e4190976cd973e3350ba8ca39957e4774a8c4e07cce25df"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "qtbase"
  depends_on "zeromq"
  depends_on "zurl"

  def install
    # Work around `cc` crate picking non-shim compiler when compiling `ring`.
    # This causes include/GFp/check.h:27:11: fatal error: 'assert.h' file not found
    ENV["HOST_CC"] = ENV.cc

    args = %W[
      RELEASE=1
      PREFIX=#{prefix}
      LIBDIR=#{lib}
      CONFIGDIR=#{etc}
      RUNDIR=#{var}/run
      LOGDIR=#{var}/log
      BOOST_INCLUDE_DIR=#{Formula["boost"].include}
    ]

    system "make", *args
    system "make", *args, "install"
  end

  test do
    conffile = testpath/"pushpin.conf"
    routesfile = testpath/"routes"
    runfile = testpath/"test.py"

    cp HOMEBREW_PREFIX/"etc/pushpin/pushpin.conf", conffile

    inreplace conffile do |s|
      s.gsub! "rundir=#{HOMEBREW_PREFIX}/var/run/pushpin", "rundir=#{testpath}/var/run/pushpin"
      s.gsub! "logdir=#{HOMEBREW_PREFIX}/var/log/pushpin", "logdir=#{testpath}/var/log/pushpin"
    end

    routesfile.write <<~EOS
      * localhost:10080
    EOS

    runfile.write <<~PYTHON
      import threading
      import time
      from http.server import BaseHTTPRequestHandler, HTTPServer
      from urllib.request import urlopen
      class TestHandler(BaseHTTPRequestHandler):
        def do_GET(self):
          self.send_response(200)
          self.end_headers()
          self.wfile.write(b'test response\\n')
      def server_worker(c):
        global port
        server = HTTPServer(('', 10080), TestHandler)
        port = server.server_address[1]
        c.acquire()
        c.notify()
        c.release()
        try:
          server.serve_forever()
        except:
          server.server_close()
      c = threading.Condition()
      c.acquire()
      server_thread = threading.Thread(target=server_worker, args=(c,))
      server_thread.daemon = True
      server_thread.start()
      c.wait()
      c.release()
      tries = 0
      while True:
        try:
          with urlopen('http://localhost:7999/test') as f:
            body = f.read()
            assert(body == b'test response\\n')
          break
        except Exception:
          # pushpin may not be listening yet. try again soon
          tries += 1
          if tries >= 10:
            raise Exception(f'test client giving up after {tries} tries')
          time.sleep(1)
    PYTHON

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    pid = spawn bin/"pushpin", "--config=#{conffile}"
    sleep 5

    begin
      system Formula["python@3.13"].opt_bin/"python3.13", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end