class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.30.0.tar.gz"
  sha256 "802dd6af0189c6a6fa9d5d2ada52fd6ed0e42f7ea473f760166a06b1fcc3ef5d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0da4998e8ad493e14d057014dfa59c18b9cfcf8c79dbb87196d9259ff425772a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b31107c7086efa0edfcdb9d92930cc53e47d8044930f68b2b71a5484e43b40a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf273810d19ad8b6f2c30bc0d9cc7dbb80a82f99faa4f3aefc3f0763dd6825db"
    sha256 cellar: :any_skip_relocation, sonoma:        "34b61e25b658d924c7f1b7f98fcb859b4df432a1f2b7dda64d691a99c3d72523"
    sha256 cellar: :any_skip_relocation, ventura:       "81ac8f2fe6d8ea85eb620ff9a5feb0ffa51037105e67525dd9543954603361d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f088b9dbefde8e29cf10695425a286049f5f42cb0d3bbaff24f675d475a05504"
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
    assert_predicate testpath"outputnoarchtest-package-0.1.0-buildstring.conda", :exist?

    assert_match version.to_s, shell_output(bin"rattler-build --version")
  end
end