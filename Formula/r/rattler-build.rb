class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.72.2.tar.gz"
  sha256 "f768bebf9102b71c450bcdbe4f13de9986821e77d9ae267e3dc68b7af407f88c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c239734310d4db314998124ad40879553f5dccd0f0a938f460ef31c6b492bf76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9ea92ccb17372cbcff35f6c4401ace6b968d5067dbcd4da740877a2099a912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b1da94cad8f8fbc4b16c2edb30067458b66f5c18b42bf487627167c1d970367"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f8dae20ad8eeda98ec6d31de40309f139e0c8c4c871ea0ad4f002fb937e1cc5"
    sha256 cellar: :any,                 arm64_linux:   "5c099bd19d6fdba14c883d45f6b4ac9b870c23600ebd1b1d09e963e97ff26a4c"
    sha256 cellar: :any,                 x86_64_linux:  "94c700eb5d9185fa17d44625cfcd18ff56121bddcf8e9ed5865a910f00ba0bd8"
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
    system "cargo", "install", *std_cargo_args

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