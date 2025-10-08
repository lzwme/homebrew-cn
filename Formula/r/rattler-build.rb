class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "f627acc54b8c559fa49e36010623bb3541955010e84b2cec3cdcbb778c670090"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/rattler-build.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "51e55bea261eed240cf3e9094e2fb38901b0930d2f98445bdbfc5199aa187844"
    sha256 cellar: :any,                 arm64_sequoia: "d5eb7b1a06f64f66211ce2e07080a0c199cc689c8677f0c35486adb9ee188e9d"
    sha256 cellar: :any,                 arm64_sonoma:  "6d03c2ae33b99ec57343d204d881f6675273a353d80717b3da579fbbcb881b70"
    sha256 cellar: :any,                 sonoma:        "b37d397cbe7ac38936daaf051e5389ec8a61555612defd9177789f2e72b1027f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "629dda90dda9d5eab2b10937416ac362156af2087b8b54e0754a988f45f73a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d1e46cc3decb4d7b7c2d3d9330178b2d3dc227cced2097d3da63c150ce234f3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--features", "tui", *std_cargo_args

    generate_completions_from_executable(bin/"rattler-build", "completion", "--shell")
  end

  test do
    (testpath/"recipe"/"recipe.yaml").write <<~YAML
      package:
        name: test-package
        version: '0.1.0'

      build:
        noarch: generic
        string: buildstring
        script:
          - mkdir -p "$PREFIX/bin"
          - echo "echo Hello World!" >> "$PREFIX/bin/hello"
          - chmod +x "$PREFIX/bin/hello"

      requirements:
        run:
          - python

      tests:
        - script:
          - test -f "$PREFIX/bin/hello"
          - hello | grep "Hello World!"
    YAML
    system bin/"rattler-build", "build", "--recipe", "recipe/recipe.yaml"
    assert_path_exists testpath/"output/noarch/test-package-0.1.0-buildstring.conda"

    assert_match version.to_s, shell_output("#{bin}/rattler-build --version")
  end
end