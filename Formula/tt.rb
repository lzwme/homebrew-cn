class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://ghproxy.com/https://github.com/tarantool/tt/releases/download/v1.0.1/tt-1.0.1-complete.tar.gz"
  sha256 "b3fa68d2c9aeaded9532d180a5ff73c38ee5b603882a0aff680fe88cf9541d02"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7d34dddbe2fed31dbbc81e7f3194d23299d8ef70ca6599e017c368134c878681"
    sha256 cellar: :any,                 arm64_monterey: "6de0d52548eaaee564e5b176f006e1e3d4fcc19527a94b7416c9d94df4fc6fbe"
    sha256 cellar: :any,                 arm64_big_sur:  "66d3cd3aa82a73a8934bdb76ae7012e439ebde195961bd830b95f15130fe6155"
    sha256                               ventura:        "2667fb8b061039ab478b75474824088c68e436beb0cdc108cce79a8dd5d0187f"
    sha256                               monterey:       "67ccc1aec007a9cb6ff37c0503b56a52be94b04dc964bb5a64a7f37b8f2c5c3d"
    sha256                               big_sur:        "f7e2518c36171cc8c46a9325facdbc9ae4b7f7a6a956e6ed9a5746d08e0a113e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b651e4eed97470aeca4692e38ee5b6acb8f33822b33fe4f8ddc2031c9848fb"
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
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end