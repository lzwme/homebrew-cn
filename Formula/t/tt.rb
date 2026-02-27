class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://ghfast.top/https://github.com/tarantool/tt/releases/download/v2.11.3/tt-2.11.3-complete.tar.gz"
  sha256 "a2061f568c599ffdbe50c6f5a3aeec8868f79dfcfa7fd6e3300aa3338fc10d5d"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed17d1a532a03561e6e153db6a533d2100d16bd78fadf0ecc8a9aea61d94e710"
    sha256 cellar: :any,                 arm64_sequoia: "2e104214d5b000958875bfe0e690b2b02d00472873d53b37fcc188245777dc4a"
    sha256 cellar: :any,                 arm64_sonoma:  "087a928e277481ff2e546a13ece611334bd1e1111612f74160e75338810032d6"
    sha256 cellar: :any,                 sonoma:        "d95ccb92dae5b4e2eef4981d64d0c1791aef7f766ead59ced4d4b750ba01e82f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dd7c38bb9ae0cd3683c3078ca30be5f474f5de4ed0b2f47f761277f7c1463f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1966ba8aa4230bd662ed62242c844ac1ef5dd095ad39313f27f01dde62a31220"
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
    (etc/"tarantool").install "package/tt.yaml.default" => "tt.yaml"

    generate_completions_from_executable(bin/"tt", "completion")
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end