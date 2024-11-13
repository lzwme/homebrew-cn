class Rethinkdb < Formula
  desc "Open-source database for the realtime web"
  homepage "https:rethinkdb.com"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  # upstream issue report, https:github.comrethinkdbrethinkdbissues7142
  url "https:download.rethinkdb.comrepositoryrawdistrethinkdb-2.4.4.tgz"
  sha256 "5091237602b62830db2cb3daaca6ab34632323741e6710c2f0de4d84f442711f"
  license "Apache-2.0"
  head "https:github.comrethinkdbrethinkdb.git", branch: "next"

  livecheck do
    url "https:download.rethinkdb.comservicerestrepositorybrowserawdist"
    regex(href=.*?rethinkdb[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "08cd5f3a221e9ade6d2e9ccad0cb73f10094855e2f362dbebb274c7dba1fbc3c"
    sha256 cellar: :any,                 arm64_sonoma:   "12c05ba1583bb06660d8630fab1a5d3335bc43fddd5827c2b34ff01660dfbbd2"
    sha256 cellar: :any,                 arm64_ventura:  "799cd7b1efe7da9dd0933b42e5bebd71dbd354be745ae898cdb1f3f5504885e8"
    sha256 cellar: :any,                 arm64_monterey: "a59635dab2420df9cbd170c6e6d09f2a3f7b3de354546aa474cd43362ea037c8"
    sha256 cellar: :any,                 sonoma:         "6762f17cd6a78747bf7c944fe6ccd37957c34f783ac1dae8ce7b1381776de3b9"
    sha256 cellar: :any,                 ventura:        "4eb3cb16e0f103c3aaf761c948d7743ad142c6f08071b3663c7bb6336cd41708"
    sha256 cellar: :any,                 monterey:       "931ed3a24d911f5548561327055106ef6a65434632d7b0c57bbb6a25c27ef975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "728c63d067ecd2ef2f0df719c1334e74a5f97486526af5ad947ea552b0e9492a"
  end

  # There has been no response to Protobuf 25+ issue[^1] opened on 2023-12-13.
  # Upstream appears to be in low maintenance state after parent company shut down[^2].
  # Recently seeing download server issues[^3][^4] which makes source tarball unstable.
  #
  # [^1]: https:github.comrethinkdbrethinkdbissues7142
  # [^2]: https:github.comrethinkdbrethinkdbissues6981
  # [^3]: https:github.comrethinkdbrethinkdbissues7155
  # [^4]: https:github.comrethinkdbrethinkdbissues7157
  deprecate! date: "2024-11-12", because: "uses unmaintained `protobuf@21`"

  depends_on "boost" => :build
  depends_on "openssl@3"
  depends_on "protobuf@21"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    ENV.cxx11
    # Can use system Python 2 for older macOS. See https:rethinkdb.comdocsbuild
    ENV["PYTHON"] = which("python3") if !OS.mac? || MacOS.version >= :catalina

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]
    args << "--allow-fetch" if build.head?

    system ".configure", *args
    system "make"
    system "make", "install-binaries"

    (var"logrethinkdb").mkpath

    inreplace "packagingassetsconfigdefault.conf.sample",
              ^# directory=.*, "directory=#{var}rethinkdb"
    etc.install "packagingassetsconfigdefault.conf.sample" => "rethinkdb.conf"
  end

  service do
    run [opt_bin"rethinkdb", "--config-file", etc"rethinkdb.conf"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var"logrethinkdbrethinkdb.log"
    error_log_path var"logrethinkdbrethinkdb.log"
  end

  test do
    shell_output("#{bin}rethinkdb create -d test")
    assert File.read("testmetadata").start_with?("RethinkDB")
  end
end