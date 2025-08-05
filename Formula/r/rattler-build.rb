class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "761f69c0fe3569373a26f45829f381e9f0f03b2ed461873d03cd3448b67f3222"
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
    sha256 cellar: :any,                 arm64_sequoia: "d054dacef30d9659ca706b626df5eb971e2f47249674f22f1099959fd8168313"
    sha256 cellar: :any,                 arm64_sonoma:  "ec533145efb0a349e3b7ff7b3f3085dd65a1009c267bec2298eff04cd9f4f313"
    sha256 cellar: :any,                 arm64_ventura: "19e0a1a62366e0e7e6144f63231318ab606e06b25edb2321ebbf7a99bff62639"
    sha256 cellar: :any,                 sonoma:        "a334d19c4ba5e565b6663a0fc7082904f0fa546456e10d0bb4320f8fc3d5e11a"
    sha256 cellar: :any,                 ventura:       "c60e51fa89fa81f101b1ce91076e21c424802b82b6c2925d8734b7283881c9e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "499519359579f50bb7a9e501d166315dfa306d5182411de387c00f20c818ca0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "409008b168ac47e8020d5c02e3896970e0da582c4b3cfb8e8adee6f8bdfe1534"
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