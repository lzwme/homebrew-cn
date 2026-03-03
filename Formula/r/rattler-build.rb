class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.58.3.tar.gz"
  sha256 "f68577d637de17f04a0506be7ac0f96134b28727d6133b678b1e74f9cd6e6c54"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f10eb1579d7483358867e609223d5186c570042c79f37449a72075e38b439a02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e1ea52ebe597302fbc82eb85d184f02bcf4f2990c6953c94474f97e88a69155"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a56e255058323f7a1971afec14a72f3a8f12754fbe2a235d9faf21031667938d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e25cf646f49765f3bfcefc8d219c18ff9b0f5af37add5eb5f48a6e64fb697e5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e44bee429b6d4767dc38f917c5670df6ddf01c5ebfd0aaba7da724f6cdd4082b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3938b36e20e8e5a9ab9cf1968d014b3c0d6f7d8ac6ccb46f97fd5c4fa2de1682"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "tui")

    generate_completions_from_executable(bin/"rattler-build", "completion", "--shell")
  end

  test do
    (testpath/"recipe/recipe.yaml").write <<~YAML
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