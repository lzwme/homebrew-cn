class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "dd5f7c716bf77d621f5a987d789f9d02072d456f1733f2aecbd16556bdc68054"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fc7c1020da8838bd5a9530a9c7b6a038d72ff0da8aad2a597f709cc579441c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14d2ccd56e71ae68cf080e8919fb4ce0c76db3b9f9d78d58812f0105d9fb20f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad40fc234ec32699fff883960e76fc32377f87a0fc561ffc746086a890ef44b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbf77cc999780116743c8b9f5bd5861cb920c4818b972d12f5fb3535db2796cf"
    sha256 cellar: :any,                 arm64_linux:   "b204e730222c4c388575193e43eddcea38932a803d598c879c28fcbf740c19a1"
    sha256 cellar: :any,                 x86_64_linux:  "281e578988d8f89eaa84c76d64d8410d86c78cf2a3dd3ae014d7edfcc064541f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
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