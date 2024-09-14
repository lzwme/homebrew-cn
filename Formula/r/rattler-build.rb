class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.20.0.tar.gz"
  sha256 "7e0b5d4e0aa77a8887d7441249d40f378261d74337c4e36fb3dd9340e8c365fb"
  license "BSD-3-Clause"
  head "https:github.comprefix-devrattler-build.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5683219f2715055f52688b4fd75c2584f2dc899b6db645189ac8497b67bb01f2"
    sha256 cellar: :any,                 arm64_sonoma:   "420f1ade3e49423277acba49bebd6ca56a77e498504428c3094cfbb271390bad"
    sha256 cellar: :any,                 arm64_ventura:  "0a54a85e7376a78933a2136031e943a36b3743f2c94c68bc5c87bf2cbb47cec8"
    sha256 cellar: :any,                 arm64_monterey: "79ed5cdb4ae28c68f89524337b44f1d49c79a7915d555706218773accea0c955"
    sha256 cellar: :any,                 sonoma:         "d64e31d6e19b3329cdae8da1cbccca10a429414e9c3fc4d4711bdbe53564a4d0"
    sha256 cellar: :any,                 ventura:        "2ecb0433626e38ec597c2831a85b8b2f79da2560a5b6491c628fa63d3909bcf8"
    sha256 cellar: :any,                 monterey:       "1191eb2f1dbbed49dc2fbbc4387f60626d849f1450ac17d0d29c40dab478ea08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b72ecb25882979d8163e752d369361516a6c6fcdfaeba7052d8bd2ea47c32b15"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--features", "tui", *std_cargo_args

    generate_completions_from_executable(bin"rattler-build", "completion", "--shell")
  end

  test do
    (testpath"recipe""recipe.yaml").write <<~EOS
      package:
        name: test-package
        version: '0.1.0'

      build:
        noarch: generic
        string: buildstring
        script:
          - mkdir -p "$PREFIXbin"
          - echo "echo Hello World!" >> "$PREFIXbinhello"
          - chmod +x "$PREFIXbinhello"

      requirements:
        run:
          - python

      tests:
        - script:
          - test -f "$PREFIXbinhello"
          - hello | grep "Hello World!"
    EOS
    system bin"rattler-build", "build", "--recipe", "reciperecipe.yaml"
    assert_predicate testpath"outputnoarchtest-package-0.1.0-buildstring.conda", :exist?

    assert_match version.to_s, shell_output(bin"rattler-build --version")
  end
end