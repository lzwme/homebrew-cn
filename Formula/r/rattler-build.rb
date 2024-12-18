class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.33.0.tar.gz"
  sha256 "197b35613a32b9b2a0885b7c501b65cd4e9e8b6c7a8ce7bb861dbfcf513af83d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96c75c6690e7908cb74562d24dcd13d573bf77e48450f077dbfd54ae6f1b3c8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6456d3391b199ccdff2b3f9dabac311875fd17622f86d668ec26d8d371ae3e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "150582c10d63d26c850932a9fa59188013b989c0e2def10bc5089abe087897ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2b3454dc12e84768d1866c4872d2c3d70e415127a95ecae7b4631af4e3af59c"
    sha256 cellar: :any_skip_relocation, ventura:       "cd35e484855aa5673dfbbbc2063620bb3d8979aacc4d4edbcfdb071a0ac48aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c9edb550825214fb0e5b083a56a5dba908ca54e8193ab4db1705feaf5e9363e"
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