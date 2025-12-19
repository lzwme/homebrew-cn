class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "d5114795043149d4011af477dc89e26744a42ed954720001041249d1267a9895"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3d0b5007c23ebf9c917e203cd5879a03cf3d3bcfd2f3d3aecfd9372ae983800"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe85074f035abaf14fa32c0d01b67468f9c248707b5c61b4fc677626e84f1449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a9a166b01f15afc58bdc7718093023a6cb2b01940b6a74b4f84adf26a0bd55d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2e5a4505737abd23978f88ad1dd244285893fbf1888abb3b4e722c556990a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f2a7508e0fced2a1f6683632f638f16d6b094096ae761dc372ca9281395ed67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14f9bfa42eb0cc10cfc78404affbbf3614538ae502776bffc8150389d09a2591"
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