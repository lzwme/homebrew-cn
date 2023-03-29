class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://ghproxy.com/https://github.com/tarantool/tt/releases/download/v1.0.0/tt-1.0.0-complete.tar.gz"
  sha256 "6f42d30b9d9f9fbad1907a49cf3394f71c2c86e3faa1194fd9372e4d8877c792"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "0d4e7c8ea9dd9bfccfe46ebe7388d960fc64dda9e152143d00445b646da9e5f7"
    sha256 cellar: :any,                 arm64_monterey: "69a43816ae2551308c5c91a0fd89c3f7929e6174f4aa2e79d22755c99db5e3d5"
    sha256 cellar: :any,                 arm64_big_sur:  "a7fff269e996ce411e34e2eb745bcc89d68ad435b2d41c538345fcba5ce3981d"
    sha256                               ventura:        "2a1d6377bf43aeb1c05af858c59ab5111832418b8ea3673fa91737938fbc9766"
    sha256                               monterey:       "a9cd3db8c3f9c6b4cf215a735ae2a4b81d73670056ceeae4415a6c73aaf87c2c"
    sha256                               big_sur:        "fa9f3a172f23970a3d4f0f4e0c9924ce82489899f762fba3f5b02bccba802d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b941d6a5674cdc7739299f3dcbf3780e74d5010f59c24436aff8201e58cde21"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  def install
    ENV["TT_CLI_BUILD_SSL"] = "shared"
    system "mage", "build"
    bin.install "tt"
    (etc/"tarantool").install "tt.yaml.default" => "tt.yaml"
  end

  test do
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end