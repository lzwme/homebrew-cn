class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.75.0.tar.gz"
  sha256 "b4dd0ad6aa2439754800a0a4f4085ce8888c5cbf66fe355dfd679db3501e3a6e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b260ea65dd6c3ac078e9bb51c1f8498c42ea57a56cd8f9f6697a9cb569de71d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c3cfc04ed5e328e05ef27cfdf0611c6ddfd8028697787b0a272a9aedec4ba11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c743fce5a1c73b467a35d4ad34e568f331e98d1b9d54d1d4a63f676829f23822"
    sha256 cellar: :any_skip_relocation, sonoma:        "41fa346cbaa4563ed2f47fad7aab541b8343451bb2e91bb279c1dea6e9b6b3a8"
    sha256 cellar: :any,                 arm64_linux:   "f19a3e6ac51183418a20cce7f18116aa000199cc0ce9ee5be5b00a885c49a4db"
    sha256 cellar: :any,                 x86_64_linux:  "606bce72225db33ef1cc19f24cd28d66187c05d872e23ad6611a1b3c14f18381"
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