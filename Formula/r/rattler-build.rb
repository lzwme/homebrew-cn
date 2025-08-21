class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "2cf4234b9985eddb5501dd8515811f74065a33077c187caed1e69a70ea65d642"
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
    sha256 cellar: :any,                 arm64_sequoia: "43232e1f95875096db699c83a33fc86827df53b5aaf63610b494002609eac2a9"
    sha256 cellar: :any,                 arm64_sonoma:  "305564e14c62e7840f4c1294243618c49cb1169c915a3df3b3c58711c19e930c"
    sha256 cellar: :any,                 arm64_ventura: "41aeb485d5cca92860d599a7d2d6f9ce3efc49a5168d6af3b9090404359082e9"
    sha256 cellar: :any,                 sonoma:        "b6841990bcd706109b17920344b01479140d9ed5b4c52550a35a06145372dc70"
    sha256 cellar: :any,                 ventura:       "e01c0636bed76c1051500434d68fbcf8e2bc4e1418b8e1e448d986f20acffeae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3537d97845635a33d6fc2642f32c5722b21682378ec5b6fc7ff0dc4fe75bb9e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "865c5e927629b76ad1bfaae37f6a5bd359a5f97858b575e2d23e182dac53004e"
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