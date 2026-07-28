class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "a41c8820f38eddbf01fe65b2c5fcd0ca08fafb4bcf491f017f22c5f5eb9f6f46"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e50789bb1484a94ff3af51b8cf11318519de42d5ba4e39df460ca8184b1bd25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f10dcdb2bb1f18a8414ffa3510cee04aa812641ed943cb290c534c59d763bfef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad0920f757f541b40005569b9c22292bcc82dafcc2ecc0f52da8034910613f54"
    sha256 cellar: :any_skip_relocation, sonoma:        "e748ddfcf889e221f663fb204ab6a40c047c6955cad239071c586ff378129ad5"
    sha256 cellar: :any,                 arm64_linux:   "67198b237dd212350c259b3812cab293038417cb6aa27fc0485ac657b63380d9"
    sha256 cellar: :any,                 x86_64_linux:  "77ab142d976ae30b74509baa309d2f8c1a6bfa8e4f41970238f4163bdfaf2d28"
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