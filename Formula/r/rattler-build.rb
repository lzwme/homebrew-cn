class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "2cf69e88e10b61bb70c48be736b9762938ee917404b193424757daf5ec47ef4d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fdf0cb5e34b2944407fd4e575ccc7ae1ed3abf08ceef066376a2f55fc30f262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb2a314d88fe9efedb6e5ca67b163899bc91d80cce411cb35db49f83ab2b2131"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d9a8f7a8cc32340cb57e4cf8834b1b97cee189124494549f25587f841a3d8a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "827f9894cb54cb692549a2f9fe0292e286545dd16428de010cd1ede4d3662c72"
    sha256 cellar: :any,                 arm64_linux:   "45f0956ad245debb0f2ed2abf8cf938e506581d6863b5bc5a265dc0f4612c131"
    sha256 cellar: :any,                 x86_64_linux:  "23bfdb08c6319502d02e9727a1cd136f7c00875a92f64cce6d185c46687ab4fd"
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