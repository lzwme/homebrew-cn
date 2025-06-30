class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https:github.comtarantooltt"
  url "https:github.comtarantoolttreleasesdownloadv2.10.0tt-2.10.0-complete.tar.gz"
  sha256 "e115bbc85230f12a69746f54e47a3fd06fd9c2fed4657e519820c9c7653cb03b"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "616e78a32fd2f954c9a8fc67e9ff52bedb18be5ab4e333894a2ce69f42805b9e"
    sha256 cellar: :any,                 arm64_sonoma:  "86c86c8623739a59a1daf8cacecd933bfa56b05340057bf4aaf5f5613ba0c1f5"
    sha256 cellar: :any,                 arm64_ventura: "b25bce86318a19428e48ee5de0282d3600d0202e69d97d8eb163177aaa81e745"
    sha256                               sonoma:        "d5b2e02943102b1ff99584b7838137d6177dd5540f3c5d70826aef88ac0c28a9"
    sha256                               ventura:       "1b68f39e32f9f32f5f6dd5a967367dfba016470025f331b76d23da17b582bbbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8329c518322e1cdd41080beb870d5379888d8d3c077f39817a98bf524f30c0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d130ae50757eaa53ebb3f6ac79bd80bcd6165c863b4ddc8089acb8480e0f407"
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

    generate_completions_from_executable(bin"tt", "completion")
  end

  test do
    system bin"tt", "init"
    system bin"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath"cartridge_appinit.lua"
  end
end