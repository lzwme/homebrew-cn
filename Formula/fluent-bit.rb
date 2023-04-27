class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghproxy.com/https://github.com/fluent/fluent-bit/archive/v2.1.2.tar.gz"
  sha256 "f51ccf6e5a05f8ddfdc64e880270c2fb08744f44a462ff719ac400f0b380821d"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "af3a5f4a298c63e72779ef29ab9d957735baf06534b1eb80eedd4122353b7bc2"
    sha256 arm64_monterey: "bf93670881f3aa950fae124c848305122bf1255aad73a7e66d74a9ed37d35f03"
    sha256 arm64_big_sur:  "ae111776ff6cb7d59c5708c901e5b2f99dfd7673bf284502bcbfd06f1a3f75ba"
    sha256 ventura:        "481bccdcdb832c442bb5cb9c1b3b662700c7e7315cb85476f0f76abc6bd356e2"
    sha256 monterey:       "1ec98e86287c7c21ec2f25709519c892655936f03f77e10c323efbb8245f6d33"
    sha256 big_sur:        "eff8922cc6855a4796ad247f9de54e8bddcd07c8345f73b0e01e5c48a1160626"
    sha256 x86_64_linux:   "fa916edcd1dd933e30014441ddb099a19f6daf4230fe8682f4649da382dbdfcf"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end