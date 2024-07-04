class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https:www.pgbouncer.org"
  url "https:www.pgbouncer.orgdownloadsfiles1.23.0pgbouncer-1.23.0.tar.gz"
  sha256 "1804219c301ef035e7f41ea9aff1e5180b4baf8845d61061e9a1085936323226"
  license "ISC"

  livecheck do
    url "https:www.pgbouncer.orgdownloads"
    regex(href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "06d543cff9f144de5784e72efe97e6d402a74615e704a8b22657e0076b1fd40b"
    sha256 cellar: :any,                 arm64_ventura:  "1c7a75a78f34cd94a01d8e3cffb0e31c3447c8a197a0eb2119835da701c5fec4"
    sha256 cellar: :any,                 arm64_monterey: "2a92f04960399ad7f6eb31881e801241655c7c9034f2e154df28ffeba6bfea0f"
    sha256 cellar: :any,                 sonoma:         "e256a28673f876da3db7c81717af0210c0f9c276f7ecceb3f0edd4cf1999f9c0"
    sha256 cellar: :any,                 ventura:        "78b13200282ff0efd0b7432a05a6e8990417382a452853311100c3601e093a45"
    sha256 cellar: :any,                 monterey:       "e5a296c28dc75c438690eddf8d2e51c4f192280cf224ff6eaeeb600e9484e8b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "469534dc80d331be9a1ef4c998b0666dba205a25412247f9119e1f861bee4774"
  end

  head do
    url "https:github.compgbouncerpgbouncer.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pandoc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  def install
    system ".autogen.sh" if build.head?
    system ".configure", *std_configure_args
    system "make", "install"
    bin.install "etcmkauth.py"
    inreplace "etcpgbouncer.ini" do |s|
      s.gsub!(logfile = .*, "logfile = #{var}logpgbouncer.log")
      s.gsub!(pidfile = .*, "pidfile = #{var}runpgbouncer.pid")
      s.gsub!(auth_file = .*, "auth_file = #{etc}userlist.txt")
    end
    etc.install %w[etcpgbouncer.ini etcuserlist.txt]
  end

  def post_install
    (var"log").mkpath
    (var"run").mkpath
  end

  def caveats
    <<~EOS
      The config file: #{etc}pgbouncer.ini is in the "ini" format and you
      will need to edit it for your particular setup. See:
      https:pgbouncer.github.ioconfig.html

      The auth_file option should point to the #{etc}userlist.txt file which
      can be populated by the #{bin}mkauth.py script.
    EOS
  end

  service do
    run [opt_bin"pgbouncer", "-q", etc"pgbouncer.ini"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pgbouncer -V")
  end
end