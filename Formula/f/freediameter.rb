class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "https://github.com/freeDiameter/freeDiameter"
  url "https://ghfast.top/https://github.com/freeDiameter/freeDiameter/archive/refs/tags/1.6.0.tar.gz"
  sha256 "0bb4ed33ada0b57ab681d86ae3fe0e3a9ce95892f492c401cbb68a87ec1d47bc"
  license "BSD-3-Clause"
  head "https://github.com/freeDiameter/freeDiameter.git", branch: "master"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "d88969b28d22359bcee5f87c000240bc2703bdbff5af20f8b47c3bfafaa8925b"
    sha256                               arm64_sequoia: "0dcb6c8ca66c2195ef3a78ab62b0e32b6303c7ea4bb31c3b5244a2c22bc643a9"
    sha256                               arm64_sonoma:  "f6407fa06f58db5b23da3d1a888a96bc68d2231cf35bd5dd8bf30129a6fcdd1e"
    sha256                               sonoma:        "b9afd84d7c426896a62987a0ad22e6504f5b4fda0ab85b2555bdce78e7c0d314"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2de09eb57cad6101295a235df9a462d905f2a95a820ea2e80d77b8f81ff6deb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f337536d0f52776b2c4daa5968b309d169f572a8132b14cfe263cf10ed79c8e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDEFAULT_CONF_PATH=#{etc}
      -DDISABLE_SCTP=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install Dir["doc/*"]
    pkgshare.install "contrib"
  end

  def post_install
    return if File.exist?(etc/"freeDiameter.conf")

    cp doc/"freediameter.conf.sample", etc/"freeDiameter.conf"
  end

  def caveats
    <<~EOS
      To configure freeDiameter, edit #{etc}/freeDiameter.conf to taste.

      Sample configuration files can be found in #{doc}.

      For more information about freeDiameter configuration options, read:
        http://www.freediameter.net/trac/wiki/Configuration

      Other potentially useful files can be found in #{opt_pkgshare}/contrib.
    EOS
  end

  service do
    run opt_bin/"freeDiameterd"
    keep_alive true
    require_root true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freeDiameterd --version")
  end
end