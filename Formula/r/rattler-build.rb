class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.17.1.tar.gz"
  sha256 "10f4b7c140294686f5f73640448c8fe7dea94c1584464ccba144f7eb8368c408"
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
    sha256 cellar: :any,                 arm64_sonoma:   "51120fbeb2eada4c185f69ab8f60acc692cb87394af39e696a89dc850925b511"
    sha256 cellar: :any,                 arm64_ventura:  "9faf09f4a5015df7d02adb4be681e831fe58e212419d81a656306895465ba8a5"
    sha256 cellar: :any,                 arm64_monterey: "ea32ab469457720b8dab5cde60bdb3df8f062bb321592566729cc9239282be4e"
    sha256 cellar: :any,                 sonoma:         "843005217356d9dc288a61d3abc1ac23cf7656ddb1ffbd3eaa1c6ccf206ab936"
    sha256 cellar: :any,                 ventura:        "e03ff9103b62c1f481579602ce64217206f15cafc45dbc4df35dbdddda834c93"
    sha256 cellar: :any,                 monterey:       "f6d0f71e13cd5144aac7e9d33c80a1e924e3958cd85991bd5bb2d2cb65773f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7c37618b4162c49f2495cd026c9317ff4bd9836630e7eac5b04d3cb4cf61d1"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

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