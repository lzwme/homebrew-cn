class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https:github.comtarantooltt"
  url "https:github.comtarantoolttreleasesdownloadv2.8.1tt-2.8.1-complete.tar.gz"
  sha256 "c513c87768341b3ad64febad9e1e3e065f6dfda31b2b5c271483dda53cf037f4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "735e65e030522183bade0975fbe71e99b6d02465815497d2f11f5c4b9a442c9a"
    sha256 cellar: :any,                 arm64_sonoma:  "14cc774ff45dbde1b15fc29b4777df553197c0bd0bad6022cd6c83d89afe1cb2"
    sha256 cellar: :any,                 arm64_ventura: "cadde2b13518c1c32c5011963659c739f27f26b737a11f8540598cb282f58213"
    sha256                               sonoma:        "a6e8784a4166da7aa71c6ed2b69551bf082695fccc02479c0fddd7472ab5d0bf"
    sha256                               ventura:       "e623e7671abdcd6fc6d2216e2d7278d2c34a89f1660109143299f983f8a3f907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03ab28ce435054786e4adbdae3f47ea8950bb865a51dfb38a330a1a84e86ce0a"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_macos do
    depends_on "bash-completion"
  end

  def install
    ENV["TT_CLI_BUILD_SSL"] = "shared"
    system "mage", "build"
    bin.install "tt"
    (etc"tarantool").install "packagett.yaml.default" => "tt.yaml"

    generate_completions_from_executable(bin"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin"tt", "init"
    system bin"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath"cartridge_appinit.lua"
  end
end