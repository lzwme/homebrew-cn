class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.34.1.tar.gz"
  sha256 "1dec2bc2080d56054e7bb1aa52fe0effa2d1f46c8debe6c372d886330ea13c8c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9dc851f329089dcdfb7c0fd9acab20539e32f58c5c899f654bd6662b1f14fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ed7b0e1c1c6ffee35bf178a497bd293aed90ba6c41390a993e45bdc3632281b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6bc911ccbb5b719aea0246cbdca59218c71e6add156a5ddc20426f90b6a61b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9930fe2a7f98063802234838eb821ceff8d06c700d9c5b5d13dcc25bd9a428b2"
    sha256 cellar: :any_skip_relocation, ventura:       "baecd747be36130c4faaf5ea9450978f69bcc98903d138688bf4cecaa03ef4ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c07f641eec35bbb3140c33e1d655b239d3c19ab585f8f214c0a6e131d3d44dc7"
  end

  depends_on "pkgconf" => :build
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
    (testpath"recipe""recipe.yaml").write <<~YAML
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
    YAML
    system bin"rattler-build", "build", "--recipe", "reciperecipe.yaml"
    assert_path_exists testpath"outputnoarchtest-package-0.1.0-buildstring.conda"

    assert_match version.to_s, shell_output(bin"rattler-build --version")
  end
end