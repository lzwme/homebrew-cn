class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.43.0.tar.gz"
  sha256 "7f90dfefea9eba7115b68ab62996df909e3db7101e25bcbbff3b481a1b4a9663"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0efd16b4964c8fe624d516deda12fc371fea18793473699de94a39d4c2035c3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8a1fbacf47cc9cbbb1f9d8b6f3d8533e322337acf4d6c60b97b3b429cd8f68e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d3ea9b6be0e1ec7f0f5710e8999e9021c515bfcd6e13eadd2e8b875ff0a6873"
    sha256 cellar: :any_skip_relocation, sonoma:        "d05b38138d18b39855b62ddcfae1c979639fa01e5cbc781b91a2c0aa23c90d04"
    sha256 cellar: :any_skip_relocation, ventura:       "1b68acf7b908c94931e887ec520f949df732db47ab185ebd57f8dc88d77e0121"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76065d81dbfd0a59547da091acb98864acbc6d10356ed4d1284b62cddd74b6f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7ea9a074ff5181152a4cb0e6287dd15aa59d82ed975d911dc18b22c4119a954"
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