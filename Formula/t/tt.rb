class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https:github.comtarantooltt"
  url "https:github.comtarantoolttreleasesdownloadv2.5.1tt-2.5.1-complete.tar.gz"
  sha256 "1668f7842dfbc158486a6fa6f2d0b96cfcacfdfe38d2356d18c74c01d39f6631"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5ac88f957377efdcafdc2a444f2f87434f60b2579817b44379da3c2a11cc29b"
    sha256 cellar: :any,                 arm64_sonoma:  "a8a979f07948f545c2cea8511d1f869af7de6dc0a74f06028541309b31f7be6d"
    sha256 cellar: :any,                 arm64_ventura: "51d4cf4016a5b94cbb5767b62a3a155b577dc880036cefedc2dea5d7a534883a"
    sha256                               sonoma:        "76f2b6df86f033e64eb71cc6b606ca1b339a8b39b3b077e0062d1bc32c107467"
    sha256                               ventura:       "6554678c3b83c011df6efbb35e1b4c2dd3a3718db87eb6422166f8cea92fd7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7517f26fa7dfead01987fbb093e3b4bfe8e2869af74dba0c984b87deb18901ef"
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
    (etc"tarantool").install "packagett.yaml.default" => "tt.yaml"

    generate_completions_from_executable(bin"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin"tt", "init"
    system bin"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath"cartridge_appinit.lua"
  end
end