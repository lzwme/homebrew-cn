class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.0.0.tar.xz"
  sha256 "da30742f51aac8be7e116677cb07bc49fbea979fc5443e7e1fa8fa7bd0a63fe5"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "72919ebaabf0290c909f9901d56ccd37bb9661a9cfda82967a874cf8b7b6af8f"
    sha256 arm64_sonoma:  "39379adeb72ac1522b8a6c456d2497fecfd528eb08b796f9968b132d9dc5f887"
    sha256 arm64_ventura: "d1c0d423fa610920130926580bdb437fbda61d2ddcec3f14a82dd12f3c2ba06d"
    sha256 sonoma:        "bd7dedda1a582a7b6061bf4cb9788402501f690eaf3ee74555574dc2fabe9de1"
    sha256 ventura:       "089f356c031a8aeae5ccb678559245d9f36cafe3ca5ac8ed2d531cea37c5f854"
    sha256 arm64_linux:   "3fc87dd3aec3d08e45faa1d19a0f7606b019ac6754fcc0518b181f987be30902"
    sha256 x86_64_linux:  "b5b9a5bb8b13b350d2bc7ebda6e6632341ec17fb8ba4d8ddd98cc1c3cbae506f"
  end

  depends_on "boost" => :build
  depends_on "libyaml" => :build # for PyYaml
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "abseil"
  depends_on "fstrm"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "tinycdb"

  uses_from_macos "libedit"

  resource "PyYaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    venv = virtualenv_create(buildpath/"bootstrap", "python3")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    system "./configure", "--disable-silent-rules",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}/dnsdist",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end