class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.33.3.tar.gz"
  sha256 "65f3f041f81e5310d4049812b6a6697ece6479a4fb209958cd1a1d2598b178b5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76b896f18bad71a402cf91c0c23e230d46567b240c9c2b9c823c5b3d60d881a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f22b245dd2dfb094ca185ef5d869a0ea032c0e5254c954ac7f04823117615dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a737c23996eb18acfb3f8c9845a0adf254a27994c36149d3e5ff84f0a4cc1dad"
    sha256 cellar: :any_skip_relocation, sonoma:        "25aa70d2c7338826fd4ef80e8347761766ab2c51c764188a69df79dae18a4038"
    sha256 cellar: :any_skip_relocation, ventura:       "896b2b5cac9a8948e81640b469f287632ed8929ddd170059fabdde8c719f115c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fb714fc98084a8faf1b71fd3e1b46a5db8496ea3d798a40af65050bc753e897"
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