class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "b2f9bc2ca9eca10290f3ad8088c7cf6ca6b1b3d79269061b1f4787e8a5850d31"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daabb5015169f4987094c91277eadf556376c6c106c692438f5e955e84b0bedb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc41ff6251d6ff5135f4e6f6ce756048fede8abda2b8e0e52987acd28d2d9a50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc9b4f7792899b8c9c8d350a6745122769dc730396fcf5f15859e8ec22576061"
    sha256 cellar: :any_skip_relocation, sonoma:        "f65985d5aeea21b5625d7541dabbe5f2afbaa0f8dfd90fee011753f2d188c92e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdeddce45c8b098e13eacc255ad7b080d0b203761a41dbda9d29c471d7ca545f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "933e5f6e4b5bf59ab1fd90df2fb50aa519f6718ed9a764413df5201fab98d638"
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