class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "1a3fcbad3d142256d4d4c8afeee59690c9201b0732be518fd541a48b0c834840"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e23c23f2560569fd0b78b1d4be7f3e440182c0677e9890a47f536f697ee3e22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c726c6bc917f32837ebb07c69944b4dcc452f156558768f59b1581457be94ed2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44e6787f2795f5c69841b86c01c0b9724fe3c77d3db7f1bfd8079ac28f4747ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f27a464b9853fd453207e8da0cd5adb0a612c0ab741ec65d9c0e3ecd1e12bbd"
    sha256 cellar: :any,                 arm64_linux:   "b4c9149379f4caca9ceb77eef5952bcb6bb5b244d16baf386b9667714aaa9ae0"
    sha256 cellar: :any,                 x86_64_linux:  "ee84a10bfd33a2b2ebd26559afb718759a8212b089bcdad477bc9d56352f7ce3"
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