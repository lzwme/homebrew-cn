class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "62c5319db95c64a29e35946d8cbec7aad3539752662022a4393d369d3a2f3a95"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d778cc4d60f003616968838f62c6eb3053bfac81f9bfa0c3afcbcc16ddfa7b4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8f99f9646de69e4c72332860aac92186d93c8d171d69dd6997a9acc0a935a6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50d014935c50bed29ee3f0605b515706e8be930e8b4bdf0416762ce91e1ab365"
    sha256 cellar: :any_skip_relocation, sonoma:        "ede028a9d22c5883bd674ab78f2e22db5c5bf7b46acb7d3037db78e004690638"
    sha256 cellar: :any,                 arm64_linux:   "a5a756ebe8fb86e0986218fa1008d138cc1fd5a1ff10780b09aa2326bf080368"
    sha256 cellar: :any,                 x86_64_linux:  "ebde439ee2178d92a6160809cbaa1633e6a6718960a843b3223ff205722f0be0"
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