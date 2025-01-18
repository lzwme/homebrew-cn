class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.35.3.tar.gz"
  sha256 "edd716f0774d94fd444fd7513665aee4fdd8e8f3cdcb0c4e2d978ca301966076"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bac7fa25b7339795e6a0529967aa1e1b3160cc77af7ddeeacc92eae890b59983"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4279c985eac17fce5bc3a54ba9c2447da10384b4aed605f0239bbbcb18f6269"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cafaa4c617bca3f9334552b8449831a2b8bc290c9951576a6f47012083061d98"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd52dff9c9747781f226b143f392a5f4085aa80f3c79d0b658109fea7db478a1"
    sha256 cellar: :any_skip_relocation, ventura:       "1b18af2daf00c556e0d731e89d54b0064fba09e952b4294dfb8e1dbb45ec3428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edddc905fd93e9d30a1361112e54993beb243e6609c104d2c1122dd3ce46c5fc"
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