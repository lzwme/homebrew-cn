class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghproxy.com/https://github.com/fluent/fluent-bit/archive/v2.1.7.tar.gz"
  sha256 "ed80291d660be19f8458d81796c7d3f7e8735eb48ec393467a0c9deca2e9abc3"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "cb4821e631ea8792cf0f907a91e6555e4914adeab1c5beb95a912c6cad0f3fbe"
    sha256                               arm64_monterey: "fbb8fdabf31eabc4e3d3d6c3e4571dfad76a31b8e53aa3c6dfb9f6d09499990e"
    sha256                               arm64_big_sur:  "11f66c6256ef6d2fc6ca550a918fb96052e5bf35fb16e93fa4720128a9fb4698"
    sha256                               ventura:        "32eb070c0a235e01134c950d8f9df8f1af45b93585c419c28928000159bc0636"
    sha256                               monterey:       "aa490fd01f123e093157cdb61930da6f12b21a47aa530b9d22405c608e196844"
    sha256                               big_sur:        "b274b6078572d518606752093762f5b6c23f00401670c97e3a15fc75cd2f1d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b22385597c36ba6b2c359fe60b1bc5329828903a221a74f45e657084721383c4"
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