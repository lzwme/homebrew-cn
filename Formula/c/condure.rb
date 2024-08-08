class Condure < Formula
  include Language::Python::Virtualenv

  desc "HTTPWebSocket connection manager"
  homepage "https:github.comfanoutcondure"
  url "https:github.comfanoutcondurearchiverefstags1.10.0.tar.gz"
  sha256 "abe4d83ae2494a8eabd036f6f455fb4d8ebc71b29d8d50a0b35a7a59f8e0ea60"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "683bb532c5a6e91587e203984dc6c38c81367053adf4bcb8f807a75aca9eb730"
    sha256 cellar: :any,                 arm64_monterey: "f003a5b4706a843c38923c62b7b24324c2465e19a1b4641f9752c2c4713e5f19"
    sha256 cellar: :any,                 sonoma:         "d2a35c97207807253e8006efb89d19c5f4cc975d4f7790fa1b32eb16408d48a9"
    sha256 cellar: :any,                 ventura:        "3a0c81c0b4babb7b68014eef2b7925872bbf0a01f5bd8ea08365d0cdfd7f9630"
    sha256 cellar: :any,                 monterey:       "186f073ec4ae5a3662415a14103650a7cf771636e9b142624df4fc92e7dc09cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f903cf69898091ab21e253665b9a53d08a0d67ac39bb00b6bb20c43051e381e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cython" => :test # use brew cython as building it in test can cause time out
  depends_on "python@3.12" => :test
  depends_on "openssl@3"
  depends_on "zeromq"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pyzmq" do
    url "https:files.pythonhosted.orgpackages3a331a3683fc9a4bd64d8ccc0290da75c8f042184a1a49c146d28398414d3341pyzmq-25.1.2.tar.gz"
    sha256 "93f1aa311e8bb912e34f004cf186407a4e90eec4f0ecc0efd26056bf7eda0226"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc81fe026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "tnetstring3" do
    url "https:files.pythonhosted.orgpackagesd9fd737a371f539842f6fcece47bb6b941700c9f924e8543cd35c4f3a2e7cc6ctnetstring3-0.3.1.tar.gz"
    sha256 "5acab57cce3693d119265a8ac019a9bcdc52a9cacb3ba37b5b3a1746a1c14d56"
  end

  def install
    # https:github.comfanoutcondureissues16
    inreplace "Cargo.toml", 'time = { version = "0.3", features = ["formatting", "local-offset", "macros"] }',
                            'time = { version = "0.3.36", features = ["formatting", "local-offset", "macros"] }'

    system "cargo", "install", *std_cargo_args
  end

  test do
    ipcfile = testpath"client"
    runfile = testpath"test.py"

    python3 = "python3.12"
    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexecLanguage::Python.site_packages(python3)
    venv = virtualenv_create(testpath"vendor", python3)
    venv.pip_install resources.reject { |r| r.name == "pyzmq" }
    venv.pip_install(resource("pyzmq"), build_isolation: false)

    runfile.write <<~EOS
      import threading
      from urllib.request import urlopen
      import tnetstring
      import zmq
      def server_worker(c):
        ctx = zmq.Context()
        sock = ctx.socket(zmq.REP)
        sock.connect('ipc:#{ipcfile}')
        c.acquire()
        c.notify()
        c.release()
        while True:
          m_raw = sock.recv()
          req = tnetstring.loads(m_raw[1:])
          resp = {}
          resp[b'id'] = req[b'id']
          resp[b'code'] = 200
          resp[b'reason'] = b'OK'
          resp[b'headers'] = [[b'Content-Type', b'textplain']]
          resp[b'body'] = b'test response\\n'
          sock.send(b'T' + tnetstring.dumps(resp))
      c = threading.Condition()
      c.acquire()
      server_thread = threading.Thread(target=server_worker, args=(c,))
      server_thread.daemon = True
      server_thread.start()
      c.wait()
      c.release()
      with urlopen('http:localhost:10000test') as f:
        body = f.read()
        assert(body == b'test response\\n')
    EOS

    pid = fork do
      exec bin"condure", "--listen", "10000,req", "--zclient-req", "ipc:#{ipcfile}"
    end

    begin
      system testpath"vendorbinpython3", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end