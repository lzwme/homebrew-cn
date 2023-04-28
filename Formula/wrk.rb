class Wrk < Formula
  desc "HTTP benchmarking tool"
  homepage "https://github.com/wg/wrk"
  url "https://ghproxy.com/https://github.com/wg/wrk/archive/4.2.0.tar.gz"
  sha256 "e255f696bff6e329f5d19091da6b06164b8d59d62cb9e673625bdcd27fe7bdad"
  # License is modified Apache 2.0 with addition to Section 4 Redistribution:
  #
  # (e) If the Derivative Work includes substantial changes to features
  #     or functionality of the Work, then you must remove the name of
  #     the Work, and any derivation thereof, from all copies that you
  #     distribute, whether in Source or Object form, except as required
  #     in copyright, patent, trademark, and attribution notices.
  license :cannot_represent
  revision 1
  head "https://github.com/wg/wrk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ea3781d08a674492c22cfb0abffa7187ab67733cdbe0e10af34004e502516efd"
    sha256 cellar: :any,                 arm64_monterey: "3c944ea0492ae252c788756d6dc400acec84debd7938dad969bc790aa02c1be1"
    sha256 cellar: :any,                 arm64_big_sur:  "05c940991aadb871cb86696bf9deb497a97aa8c47c2b90a5db315a97353331ae"
    sha256 cellar: :any,                 ventura:        "3951a16693e0fe4eff8840756e07d72f69092c8df132d8c46400a261b7409d1f"
    sha256 cellar: :any,                 monterey:       "26df9fa20827d8ed4e82fb998f10f95ea18d2da2cf9e21b5562da1d4341ffe3a"
    sha256 cellar: :any,                 big_sur:        "be3c47b4a905ab1d9ac14c42a16877548ffd9b6777eae757c974f0ad5928a85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a2f57e3e9591a16d1b26a5daaed5b2528d06c0af6b9f1093a195dd913cc868d"
  end

  # TODO: Switch to luajit when https://github.com/wg/wrk/issues/516 is resolved.
  depends_on "luajit-openresty"
  depends_on "openssl@3"

  conflicts_with "wrk-trello", because: "both install `wrk` binaries"

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    ENV.append_to_cflags "-I#{Formula["luajit-openresty"].opt_include}/luajit-2.1"
    args = %W[
      WITH_LUAJIT=#{Formula["luajit-openresty"].opt_prefix}
      WITH_OPENSSL=#{Formula["openssl@3"].opt_prefix}
    ]
    args << "VER=#{version}" unless build.head?
    system "make", *args
    bin.install "wrk"
  end

  test do
    system "#{bin}/wrk", "-c", "1", "-t", "1", "-d", "1", "https://example.com/"
  end
end