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
    sha256 cellar: :any,                 arm64_sequoia: "1f8a98013c734d61cdcedc8d0d33cdb108c57658618fd0315c67485df37bb995"
    sha256 cellar: :any,                 arm64_sonoma:  "714aa4b30f9dc882186112f8b5f44edd148129400792ff333ac5030ede340462"
    sha256 cellar: :any,                 arm64_ventura: "0724e06cff0d38abe96c3aaf608fbd75d02836316f6dcbaa0e60d3675064d910"
    sha256                               sonoma:        "82c6635b3e7fb55db6be341d8982de18f66e7ae8b5ac67837bba20ac7b2ba439"
    sha256                               ventura:       "1a3fdaf1b8d3a2469f7372a6ed5afb12faccba2a22aa9303a04c51835249d899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcbb83bee9a6a46d294bf744af57bc25289ed794eff8455ae10e4b1ce06087ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6e2f34113d16c75e8803f39ca737210c7d177325ff1c6955c6b34f14543ae2d"
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