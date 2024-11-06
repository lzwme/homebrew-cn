class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.29.0.tar.gz"
  sha256 "972ee25d38b111cbe9db1f6b80dc674c2835d1b6498020ac72b43dbe64a2dca7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d010be24fafc420596702337bfcf1cdb41e93ab132682eb01a33f33a1fdcb12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca35e79204f277f74847476414ace94ae6b44eee337fae407d555f121d5d8ca9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f8e17f94ee701aacb1d0ec0fd984c90d5a1ab96c645da038f580805e72a1ae6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b119a96aad37e333976d31d881079026511a4dc761014002aba43dd13a2c577"
    sha256 cellar: :any_skip_relocation, ventura:       "acaba78ae75484c3b7b9847c9e656c47e5ad79cb449a327afecdc93a2352900e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b317108e21ee65c7c7447a60efb69d440ab071532d8ec1da4c3c2631e8890185"
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