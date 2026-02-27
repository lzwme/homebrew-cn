class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.58.1.tar.gz"
  sha256 "09f70924bce90cf9d956c95f6add705a10e0dbdffecaf2ba3fc0da36ebfd01aa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0d1c5014d41396eafb2b8ca9c4f299bcfe5217ad716d0ab53d78081deecb133"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6479bc84ac90896b414ba88984ffdd1904a59bb61cb2f11c5b5d1176f69cde9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4b7e6575bd37b3c706dc5888c862e682a28cd14f5284a06abb6f2797b46e1fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f11a8894e2e9027f0118cdfd6c8f550ff4cf03385d484d3d4b02b7a0b3522863"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c952ce9e68baa68901e9373db0000063e94347aff07ac70e343d4e26dd81ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf59075020972d98b543940c396a3866403b4065854b39092573fa67e76c6cd0"
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