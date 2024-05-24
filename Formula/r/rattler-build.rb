class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.16.2.tar.gz"
  sha256 "4b27ee2dbebdd16601a3459ba5cc536783b6251e20bdf4769aa99e0099131032"
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
    sha256 cellar: :any,                 arm64_sonoma:   "35899b0bfa19d47d5ba8d63a473d3895ae8c541844bbf20802ac2d22489dcabf"
    sha256 cellar: :any,                 arm64_ventura:  "6910305dd24a1c6d90b023d7add319a2d2e9996a7355adfd90fee39d64d54ae0"
    sha256 cellar: :any,                 arm64_monterey: "d454d39466122c3ee25cf6fc19c167273a3b4c031b2faf0a4fabb84610b6f609"
    sha256 cellar: :any,                 sonoma:         "cbec9116943b190ca0f36fbba2a04a836c863eed706943eeeb8b436e3e3b4abf"
    sha256 cellar: :any,                 ventura:        "dcf53302b24b807f4d13d9511b48de3570986b6579f893d7f4e49baa69828a9e"
    sha256 cellar: :any,                 monterey:       "f5f8cda3312a3c1eeb8011eec9b8a76d9fb3430967ac068f71e71207348b768d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "331f0ae4d43128d40cbc0021e946fb53b601056a35f9c8b07f0165a1575e6418"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

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