class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.35.7.tar.gz"
  sha256 "37cc3b3d7f09d09d59fa2beba939d99404d9b94c4b822443ffb4da2623df4eaf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "510a72fed2565e78cde624eb007f60ef743817ae171fd444911849f1103ef200"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e757a29ce5110a2aaeca88b82f274712baafb43685f293b5a7c4694d41b7d024"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7626445b1e6d2b83d93faa1df7d317687541057aa0050c0f223a1b65d6e83160"
    sha256 cellar: :any_skip_relocation, sonoma:        "276405c1a75c2edd5def04e724e2bf846f36e869c05448d1d8c66dbe3cf87a96"
    sha256 cellar: :any_skip_relocation, ventura:       "b1e0b401d80e7c292161f030907b69bedc1137180ed25aee4d05c671dd53509d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b94d527329219c804c9cd8d5df0946cda4aab5a4c0badd2d7c1bade5807d171"
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