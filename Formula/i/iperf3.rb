class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https:github.comesnetiperf"
  url "https:downloads.es.netpubiperfiperf-3.17.tar.gz"
  sha256 "077ede831b11b733ecf8b273abd97f9630fd7448d3ec1eaa789f396d82c8c943"
  license "BSD-3-Clause"

  livecheck do
    url "https:downloads.es.netpubiperf"
    regex(href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "48aa0230e11fbbf70eb4ae59ad08d8241a1be126fd36f4bfbb39afe2c9fc2d9c"
    sha256 cellar: :any,                 arm64_ventura:  "433c3048da89f9802a68c45eb9f6e2219e47bd79267a913ad4793c827bb555b8"
    sha256 cellar: :any,                 arm64_monterey: "92ac370795eca7e4296ddd0bf593b537c7b1fd59541437ba368010b87af42b13"
    sha256 cellar: :any,                 sonoma:         "d2bb834df9e18a2ba3d00151bff1eb04703b2f071a4b762a078d92b32963a92c"
    sha256 cellar: :any,                 ventura:        "257cba92d70f7090446aca61b58d96bf544356152e5383122edac6ad3329b0ae"
    sha256 cellar: :any,                 monterey:       "b9c3c8721ac603d5dd14d788d66b7b38b4d5d0a35a22f3b196baa2f9a796b292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df64a5a87fd4df75324e768a0d07c401e2f5dd9afb73bb322d95ada46b307ea9"
  end

  head do
    url "https:github.comesnetiperf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  def install
    system ".bootstrap.sh" if build.head?
    system ".configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-profiling",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "clean" # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    server = IO.popen("#{bin}iperf3 --server")
    sleep 1
    assert_match "Bitrate", pipe_output("#{bin}iperf3 --client 127.0.0.1 --time 1")
  ensure
    Process.kill("SIGINT", server.pid)
    Process.wait(server.pid)
  end
end