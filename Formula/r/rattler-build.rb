class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.31.1.tar.gz"
  sha256 "844a399e4c1625456dd6900d49d0115c8da11c117f06d26d75cb104cc1edadce"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71036e4ac28eb00145717d1db60a8c15a34a95421852ca997273cb1371a0f9d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d77210b32746492979e226c4917fa00b5d5022362bf6e47d47d9b47bb9294946"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e73e10e87e704c3b16ccb0c0c2c4bbca5d415ba551615ad87b48df50678228a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0242f8fdc46a0b447fc53324faf3b50e0120ce07f608b0443dc4fff3df8190e1"
    sha256 cellar: :any_skip_relocation, ventura:       "d37f49210da594bed9ac870f4438774a04bab711d0c4177d866bc52957adfe79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e30fa49f9291a7d3aa161e77e7a31eab390de8b2fbea90a985dfcea1f105c5ce"
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