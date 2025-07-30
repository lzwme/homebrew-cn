class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.0.0.tar.xz"
  sha256 "da30742f51aac8be7e116677cb07bc49fbea979fc5443e7e1fa8fa7bd0a63fe5"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "dedc86e6490fc2d3ee19848d21e710a0671b4b366effe81ad5e51a6d96e99640"
    sha256 arm64_sonoma:  "2fc046179361176023daa6f76b78c1c8c3c88bb1aa16b30af292002d5a9882ef"
    sha256 arm64_ventura: "08cb6165180a71956e32fbe05da5d0c8801a49fc6abc90a8f4d9780e988b5e0a"
    sha256 sonoma:        "28e522c9c3c32bcda2eb114eca36a331a202906d9812a17e558b43ef0bd3cecf"
    sha256 ventura:       "89bc47322c385ceaff2e135b7234e95bbba84e95d955be282fc0c6f73c81e7dd"
    sha256 arm64_linux:   "098ee30431ee79b80458c5fbfe1e5bee902c0c8a2cdb15cc66174719357adaed"
    sha256 x86_64_linux:  "6c0ab154479464328731732032552c402237e4f04a27c836c68aa2dcf825d423"
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