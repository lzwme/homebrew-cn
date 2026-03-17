class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "a64a7de796f07f0e15e6b59234d4987621462bca11ddc6ef5a57377cbd2823eb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfcfb849a45413d89fabde99f622ef8cbb8eb98dfa60659a259c008456ebd743"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3899a5e666d64ffd0f17d8ed9ee5f2519de44c1bcca7aa1bbc9073e9b1fb5aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20fe0f322cc199327c29c891e1d0efab9d9f2dcae7ad3d0d5042c7cb2cedbb10"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a5edd415386b4f87cfae04913fdcc0995239a0b8214f6879809b0ce5e82536"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dbffa98f3f3a57b919cf53779f9bef3b234e8bde22e86688053f19693bba8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f1036eea390efce12d3e2507cfb221690082d262cc7bc888e076340718e2866"
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