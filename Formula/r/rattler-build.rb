class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.18.0.tar.gz"
  sha256 "b1efcc5138f0ec264c624cabc0ed0bfc34e33ec7f54cbf6295e12558f6693072"
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
    sha256 cellar: :any,                 arm64_sonoma:   "cf4f699a4607672221c0dad15b7c094c48c807a764156a80fef206efdcfd3948"
    sha256 cellar: :any,                 arm64_ventura:  "ea1326bcca9d77be065bf3cfe3a0092c4eb3b64937b174751989277b9873b9ea"
    sha256 cellar: :any,                 arm64_monterey: "a27e64330e1ef8f9091f996f0033b54aa7918ba5277ac897dc9dee7fcf4ddce6"
    sha256 cellar: :any,                 sonoma:         "4622025635da018984a54626e6a922effe4298c9d175b9b1404b3d8be9499bc6"
    sha256 cellar: :any,                 ventura:        "e561840d022539753e06748d4c80404ce11624a6f31435e57e5a4a804aa24da4"
    sha256 cellar: :any,                 monterey:       "438939c51596d0600ca494d824669aa6637e58f09eeec69981adac89efae15f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08955b08f1455be609869983bfcba51dff831e6c27d7c790741d1d469862dd90"
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