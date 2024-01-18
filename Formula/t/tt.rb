class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https:github.comtarantooltt"
  url "https:github.comtarantoolttreleasesdownloadv2.1.1tt-2.1.1-complete.tar.gz"
  sha256 "42bcb848c66a1cc7f523a6531de84955ff90035beb8fee172d6ba4149aed665c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1820472ea0bac7f3b79306a79bbaeba23e2b65bdba98de02f5e5e24be52875b1"
    sha256 cellar: :any,                 arm64_ventura:  "ad9b1b34d21ebad6b833c027ceb0bdf727afb3dea39326d9ef7fd1badf4a1a94"
    sha256 cellar: :any,                 arm64_monterey: "565dadac3983f6c64e9f30d1b724cf64713f487c6de7413dabad57a8ba4d081d"
    sha256                               sonoma:         "3832dad2fbc93d031b48c3c91686f9f47366cfb9023439c4a0f8bdcbe9f9e935"
    sha256                               ventura:        "425e2cccb391aa1c80aa4ee56254a00f91766a90c6abb02d6f4e7c18a29a15be"
    sha256                               monterey:       "01c429d6720df6e67e6deb87090269e2e2c70b7b62f7b85583f2d38d3b60df0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65a9ab7d5fb987f2425fcb931a4676c8b82f1d4a277d08bb3363fcee029bba12"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkg-config" => :build
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
    (etc"tarantool").install "tt.yaml.default" => "tt.yaml"
    generate_completions_from_executable(bin"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin"tt", "init"
    system bin"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath"cartridge_appinit.lua"
  end
end