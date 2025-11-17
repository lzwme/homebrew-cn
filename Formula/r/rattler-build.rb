class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "a766e8c198e99affca0b352cdba81302d9d729ec17ec1cc93756d565006e4276"
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
    sha256 cellar: :any,                 arm64_tahoe:   "ec40205f7fc174260e52d77eebae043c08f72a09c9cbbd8a2d3183a26614079b"
    sha256 cellar: :any,                 arm64_sequoia: "99ac0493c9246445449c99e449d47ddd865439b134ab1c0f118d3851137f72e6"
    sha256 cellar: :any,                 arm64_sonoma:  "9458eb4afde213ab6db98dfee9f28c0394fe10e4231f689b9e3c44a93dfe90cd"
    sha256 cellar: :any,                 sonoma:        "7b117ed218c1320f2c8628464027c23d85dc97c32bac98d156342d34e487f691"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eebce848f12894a3f43b73bb29d8a6661043fcae331c82d11ec4fe28fdd0fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7060e33ab03659a6032fe631852665f47f785046d62b0c6a529dee0cf94b942b"
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