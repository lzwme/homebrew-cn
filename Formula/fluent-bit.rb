class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghproxy.com/https://github.com/fluent/fluent-bit/archive/v2.1.5.tar.gz"
  sha256 "ea2011b45b57ef5c4412d7afba151e93da189a5464eeabcd9dfb1d01503f141e"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "2edd811781446d370a87b581cc514403f745c7830575fc796af6c6267feb008f"
    sha256                               arm64_monterey: "599431a53a991569b01e44705cfba1d1dab673eaa89f94eff6aed972117075fc"
    sha256                               arm64_big_sur:  "43dbf67f4a6423c892bb293139f56eeaf9481c8a339da94553450fda4f283888"
    sha256                               ventura:        "a0d7d1595951abd3b4e71161c04461e05baac825bab26d79e30d7b007e28e855"
    sha256                               monterey:       "6962cbc30874ce2b208a706ab08a22439112761faaa7cf2e5b982903c9c2f145"
    sha256                               big_sur:        "5da98cc21da58cca6b7dc2bae6042ba1fec09a0cf0be6e824d3e9842ea744c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11a740bf600f46e185222ffe2031e518fc0485bccf578c2677a581058f66c835"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end