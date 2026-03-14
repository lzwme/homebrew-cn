class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "7f5bbd1052c7f79f793d03ec7c0b9e100c36be4776dedcc6adb0ac8729bf84de"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a2668cf4ad0ad754a39a4c943552bdf3cd391e7edbbd1371d5cf177f9b20c0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c65e34b2a8da7fdb91738e5aefac3a16e97ba8b50ec8bf44b38ad00df4c2a4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0152749e089743e06b2dd5339bf1f65a8bed37813ac4c1a1387aa569b523cbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "62a4041e486635826620db347d4f21de6081794d0217864acef9a0105751ea04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f31bf726df733c5728524dc7ef09d76c07f76fbab6bd2b7d8af6c1700185a598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5817083f981a748b73c1662e5413da11a30f7c371d0011c2f23bbd68b07d4e83"
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