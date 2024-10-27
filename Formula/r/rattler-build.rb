class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.28.1.tar.gz"
  sha256 "c4de62bcc4191bc7e41ae04ca4126d0f10e5792b6e058bd0aadcdbe47f245d0d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a521a697a6d990d1b8154d436eeb92529afcd77d69060b4ae52dfaff900cafa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc97a42acfa1eb3ef22e7085fe056a19021ea6d69eb5b73b4be6568674121927"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09ae1733549f47e33287cf7ea3d81ceb676617d457b23670fc961fcfe881ac61"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e3c467a87a9b04ad49b79239dde9dafda0181428bb64a4108cc2cb57c9d7bfb"
    sha256 cellar: :any_skip_relocation, ventura:       "589d3134440c14ab7bf080428b9cbb3bfc767c0834b2f723a29e2a6b732a86c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65e019281fe2c561f0072a4c55a19d3856855880c828cc34c96e601ec7bf4611"
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