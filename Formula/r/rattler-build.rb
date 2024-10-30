class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.28.2.tar.gz"
  sha256 "fe2b0fe1ac8b14d2896dc2c18dcd4ff1a2c971995fec68b77e42bf6a8cf6441b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "841aa188db17c5ea9fe25d5486e2913dd4ca0a75a2ed10442c674ba477e2ac57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75844d45dd47847bddfc40327aec6eb9a430394bbdd65cf657a6a3f904caa990"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78c2c88f12e96a7792fa5f576136aa7c964f502d2a31bd4bf818af5fd1b388af"
    sha256 cellar: :any_skip_relocation, sonoma:        "99ea92aea6601ea5c7efe8d78b407580d49d1a712b72d84c6dd45afe8f2938a3"
    sha256 cellar: :any_skip_relocation, ventura:       "d97cb5aebfc7d8da6cb7f2228acdd7af5082c65e06c4f5b2c651fb15f3cfa279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f3c6dc7d76501cbc218bf1136476784d0233cc686c23d08652a92ee8f191010"
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