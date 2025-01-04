class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.33.2.tar.gz"
  sha256 "7ed3422b10e087d79fc09117bcba812924004dadd68fbd9c5dd70d267f2c011f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a87d59e7204dccbef9c2731d2307231b815445c106b329be05257911bbc0383a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1154870e6922a9d064025fab1519ce971d69bb9d140551c36c1420f79988e1ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67e2d593cd90a2a6c357248ad953f64379a7e19e26aa03247d6329226d22ab57"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e7b7f98e7278de1c36f6004b367698dba236238144ebb661c28bee2ec2ad160"
    sha256 cellar: :any_skip_relocation, ventura:       "194885bea8a27849f2de1da02093bb733e0b1ff0cb45c0833b92669658eaca4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "988518d9d98ced1e11de557322850918bad57df86777ca3447ddb553fba8434d"
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