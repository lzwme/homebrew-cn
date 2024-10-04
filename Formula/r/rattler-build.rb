class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.23.0.tar.gz"
  sha256 "90b5e9eed4755b0529d35e5d6f548c57953ebffe7f8e9be4a708070f86a70881"
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
    sha256 cellar: :any,                 arm64_sequoia: "13ac351e89bc12097751732c508dc2a8cf2dbdf0325e6c555662818c26bf39b0"
    sha256 cellar: :any,                 arm64_sonoma:  "70fd24e51006174c5b6f28ca6c93cf5151ab2542a20c232b4562c6085ec9954c"
    sha256 cellar: :any,                 arm64_ventura: "e600b7cc8b2dc67c20aa987e5d1a36366c843f9b0c63e877ca5219393490e737"
    sha256 cellar: :any,                 sonoma:        "0cbd17930e7dd81c8b6f6abd718c5b61f582a3e4b1cbd0a1474857ad9060f600"
    sha256 cellar: :any,                 ventura:       "346afd6af309f5697aed4978f5ecc5d1ede495f55e127043074d313755125a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0894729c34f86e126535d3ddbd0495a8343740b1ae49ebe025ef8fac16db31df"
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