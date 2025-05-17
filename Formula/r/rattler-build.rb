class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.42.0.tar.gz"
  sha256 "59094e3d07fbe991c91f98ef511df2ea7f265be89de3d1e5dbee29242668b27f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "477ccaab3b49173a770c14fc303e0bdc04b84d09b10b05bc37bc0b06312f3f09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adfb36bfec9f603bfbcba547b1004ebaca969673356f0376722af5103169d677"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e58ce9e4ec885618843fd0cad7fa39cfb524b1b7df75a87b17708098806254c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c426de3920053edcdd3a38eee98fdfff648baec0f7ac81fd185158937b964c19"
    sha256 cellar: :any_skip_relocation, ventura:       "df3e1b4d22879422ada9b0d0ae2195ad4b6a85566c01c1dd8afb70643e915412"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fbc6dd954c5274a7ed2368a2d96b731e498edd3803ebf34f3af4d301c8b2573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aacde1fb934acfc24532abf2e7e4f1ed31701f82ba532aea50b6292abd65b2d1"
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