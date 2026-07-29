class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "67b5655865778960a72fe59c2a98742a1e6f9231c452cbf4559f39fe6f5d020c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "049543dbd9e9c7ea0b0134ad5696b6b6f5e4bbd8b68efbeeed2e9a0a2ccff41d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3cd64f0d3e75d48c97443ec727df1d35db530364baf1b10f958a0d7afc37eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849f2c75e793198788da008e8667a9fc8891054a36ce69875ea1ba4e1e2bf0a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5215aab31a4bd0ce22050bb8b25483771305a20184c3f011f77a4f53e8e35dc7"
    sha256 cellar: :any,                 arm64_linux:   "e3b01b959765e4f27959c8e68c7749a6b53f5a782ed13433a0c2063357a4e58b"
    sha256 cellar: :any,                 x86_64_linux:  "0dcebfa13a036ae0dc69d5da80b7cb8543e7bba39749a2d603ade3e6db7500d8"
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