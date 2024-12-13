class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.32.1.tar.gz"
  sha256 "bb091851c634fc60fdf29def396415d82df1a628ca0126476153de08b0c2c89a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "422e5f895f7990bd1c64551c441bc3483bbe6b8aaa9d996762982162e4f5a3f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdee8aa4df777c6d288ab5c83b8f7d1600c0f9db19929e372327f82a3908cd55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aaad6bb8bd212ec03682183e361a44335970924b059f6fa227908b9e19c512a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a7d256b51de829f0eae034f142c0044651d0b496041aaf6a2796abcca27dd35"
    sha256 cellar: :any_skip_relocation, ventura:       "5aa66a720ee9d433367c500a46e48124e61cca661ce69554942a3eed1dd6410e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "332dbf9963912802d5fa072a16c50b66d14261a757dd7e81854ebe2a7b9a1c59"
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