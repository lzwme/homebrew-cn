class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://ghproxy.com/https://github.com/tarantool/tt/releases/download/v2.0.0/tt-2.0.0-complete.tar.gz"
  sha256 "f266d8c6e3e9b34c377b52c250711ec60bea3648af4f44780b05804bfab51978"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "53ec80fadefed7f27fc95d981edb85fd1d8b09d2366f3be58bcecfdd97bc7080"
    sha256 cellar: :any,                 arm64_ventura:  "49a89044bc2928dae22e186413faf52566c04b45a46c5b851136d40a8cc51e2a"
    sha256 cellar: :any,                 arm64_monterey: "3e911b6088fafb201163c4c2099659e760a133f0b841f3299b91e0782d7e6b8a"
    sha256                               sonoma:         "87e20b28b097ddee9c34ddb65b6d792a060381a1244713e8642a63b3385458c9"
    sha256                               ventura:        "58125c223f8bcfe617737d39793f65b902a13ab25e67d6b5356c97f41dbc0b69"
    sha256                               monterey:       "33b846992a50d49b657d7a86bd0318169940acf8af23faf9559efdec1dbf5d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62c0d18060ba1077b5e73fcb63c578f2ffdbe95116956f19cabc81c93130e9c1"
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
    (etc/"tarantool").install "tt.yaml.default" => "tt.yaml"
    generate_completions_from_executable(bin/"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end