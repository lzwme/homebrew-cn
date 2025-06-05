class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.4.7.tar.xz"
  sha256 "dd346ca6f3afabcdc5e9ba09dd667b010590bb66a42f4541021fb9d6f073dacc"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1fb8278e561ed7d9a99f4ba23c25a88b537dd237e9db452e4b62717c48130841"
    sha256 arm64_sonoma:  "5234cf8758edf2892799102953dd273394716cc5be1a9841012b269da540d8cb"
    sha256 arm64_ventura: "a7744ed3ae7ac074e555e500273763bcf8243535b211ee9e2d6bb70dd70ca044"
    sha256 sonoma:        "bb04dda43aa53b3dbda4ef5aa899c81cccceb6dcaf2cf927a3f4b74a7d24ddc2"
    sha256 ventura:       "553cdc9c373828a8fb90b87d6f73723f294dc3a0a5021d18eebdccc7b4396750"
    sha256 arm64_linux:   "9e9a49395d66917fda7c89d86d2df83def6d3d91c4f3a733af2dcf144e6dd806"
    sha256 x86_64_linux:  "c1f15009c4df1619d610ae555a92c0e1cec16bb65f03183bc7fc25e849127e79"
  end

  head do
    url "https://gitlab.nic.cz/knot/knot-dns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "fstrm"
  depends_on "gnutls"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "lmdb"
  depends_on "protobuf-c"
  depends_on "userspace-rcu"

  uses_from_macos "libedit"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/run/knot",
                          "--with-module-dnstap",
                          "--enable-dnstap",
                          "--enable-quic",
                          *std_configure_args

    inreplace "samples/Makefile", "install-data-local:", "disable-install-data-local:"

    system "make"
    system "make", "install"
    system "make", "install-singlehtml"

    (buildpath/"knot.conf").write(knot_conf)
    etc.install "knot.conf"
  end

  def post_install
    (var/"knot").mkpath
  end

  def knot_conf
    <<~EOS
      server:
        rundir: "#{var}/knot"
        listen: [ "0.0.0.0@53", "::@53" ]

      log:
        - target: "stderr"
          any: "info"

      control:
        listen: "knot.sock"

      template:
        - id: "default"
          storage: "#{var}/knot"
    EOS
  end

  service do
    run opt_sbin/"knotd"
    require_root true
    input_path File::NULL
    log_path File::NULL
    error_log_path var/"log/knot.log"
  end

  test do
    system bin/"kdig", "@94.140.14.140", "www.knot-dns.cz", "+quic"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "conf-check"
  end
end