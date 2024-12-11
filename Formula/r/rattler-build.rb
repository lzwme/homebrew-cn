class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.32.0.tar.gz"
  sha256 "58cf11c43a70915fd312fd3095a191c36df4156c1bd539a306c3c247f0eb4b35"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "475ce73208ddd3baf3e8b00ae2c391a5b908984d9298367347361b7b0b909385"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7984aa3f3e9da31450cd48eeabfbb2d3c31e70c15afd03f333a831ce1e75ee9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb1900e1069fff41645fbd8202ff0d638af240322477735408f9d53364ffb653"
    sha256 cellar: :any_skip_relocation, sonoma:        "fffd41a43b977d88e074540b7c38f8a9316accf875e75cc638feea0ae95afe13"
    sha256 cellar: :any_skip_relocation, ventura:       "900ec304b31c55dfcba6b0744651e3351cebbf335daa24c59c490b048bd7acce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad6c6ac11914ef9225e7bbb431322286039afba2a8f93426ba4d8615002fab8"
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