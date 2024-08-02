class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.19.0.tar.gz"
  sha256 "c9ca936aae5ba5e63115ad5076b29c8f7594adb3d588a29ebeeb0803152dd11e"
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
    sha256 cellar: :any,                 arm64_sonoma:   "84911d57cdc679b34cab069fd5c4c82311b37a7b8474dbb6b2cdf29991c98d39"
    sha256 cellar: :any,                 arm64_ventura:  "4100fceb7165c43cc11b867258e51cad26ece4bf8a14d95b4252e4e9c6bea534"
    sha256 cellar: :any,                 arm64_monterey: "0ac00fcf56651e9acfdae16c8a9a6dfc2352caee7261314f6ac2595d85c7165b"
    sha256 cellar: :any,                 sonoma:         "725374889cd4dacb4aa06d690159299f7c70989f1be40f9b601799601a759eab"
    sha256 cellar: :any,                 ventura:        "7ea55d396c3dc6aaf894c8e227eebeb844b3374d8b4ad0cce6aacffaddfa8c43"
    sha256 cellar: :any,                 monterey:       "3fe1dee674a3960ee2243d6fff09a1eaae224a2b7c50024092ff505166b152b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd42703bc8e59cd916b80d18138ded993444352c11e5e59d7f5a40fa2251266e"
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