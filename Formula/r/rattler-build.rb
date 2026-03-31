class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.61.3.tar.gz"
  sha256 "077ba671f520673055466aec1aae34bd9c08f85e727e36136188395869e9c162"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99d39a7b9caaea3af54d431bf0beb1380c86504a78c2c3accaf3ba849495f340"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a9bbe7fe22ea9d83796cbba687b0ff6a442fa5b599e3b6427844d9818ac687a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1050d7c2c07ebc5acb966dacdaf64b97b5f71215dadf47ba386560b9b51a217"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a513f740ada17f4d856c7a2d173b6ccc07ec72c5f1a6857680431e9c6a0d013"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdc42c947b97f171012e5ce0aa6e7d4d758c75a6908350506743f152f2593774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77590af989609f3cbbab588d4ecadea11258db4bb6c50bd3d5e712bb43cf146b"
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