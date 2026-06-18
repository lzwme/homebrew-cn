class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.66.2.tar.gz"
  sha256 "bae642cb19f1f8b15f7bc27cd8973f4f8bb357f62f57094a9d09b66d8a699e52"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aea3e5bfd86868fb130f1c2a36c07fcc1c870b192c22887b0be4241d4ed45143"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c38f30526e12be5e206c4bf7577580f833597aa9eb307ee85d49d8e3a49761d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4b9f88ead21c29a120120aa7763b327d37984f4d71ff2a27fe01e50ae3246cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcccdbb5d38dddf951fb717b365175510cd4756686f89d911cb87d86ba790d3e"
    sha256 cellar: :any,                 arm64_linux:   "c4853b23f6611fdb5e7ca0e13d7c57eb817f1c2d198d83714d8ea12b4563a86b"
    sha256 cellar: :any,                 x86_64_linux:  "f8a5d0d6e857c36dce36259916dad889bd6698a7aadea716ec184d1d346e2e65"
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