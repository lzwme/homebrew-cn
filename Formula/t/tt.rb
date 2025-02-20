class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https:github.comtarantooltt"
  url "https:github.comtarantoolttreleasesdownloadv2.8.0tt-2.8.0-complete.tar.gz"
  sha256 "8d723623cd34f511860b73f01b80128060a22b0e55b91a7d48f695c0928d8d88"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2d8e97070ddb2eabee7537b2d640d24c15c56b01b1e7183da9afa22d0639b8b5"
    sha256 cellar: :any,                 arm64_sonoma:  "d98323f0fa534676deb045bfdcbef8aadf2abe5b2faaf2c76aa35057d412af07"
    sha256 cellar: :any,                 arm64_ventura: "29db5af24e1b1d03160be05c05f443b9651db6f8157e0f23a341be0f0ea2fc6d"
    sha256                               sonoma:        "497ae97f360c5119524ef90ffd93d3b691b5110daa89190c252f4e0899171edb"
    sha256                               ventura:       "f6e02bce3f9b2271ac7cabf70f75e76e7683e0b146ba3c8c98d928e8e1931c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f7b656578f60745b755c264750175cd133aade236d2bbc768410d6cd8a6027a"
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