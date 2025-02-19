class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.36.0.tar.gz"
  sha256 "bc99bee1fa07926cc4cfa8995522bca65210df158cc2bf2564a8e3da211d231a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eab2fb264c16652cf52be27bd5d04fca7f0b0b4630a3c77d39c02104868c9f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3cfb79276787b523c1d7b7cbbed5ffaea1b24db4e95798a180a3b64eeb3c8ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08892d2a8dffe8cc84b1b9933c615cadd28ad6a66b885e3a814b89e99f306e3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3652eedede25dd7b2ca41fd581e22355c0b151626a29687ec87c55d69b190eaf"
    sha256 cellar: :any_skip_relocation, ventura:       "7f0fe408c671a39d16f24977795c62b681d1324e2b8546981282fdb6425d58a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f109ce05a18cf2210f1d53577612a5350cf330bc6b7cddc4dd3610846ceada5e"
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