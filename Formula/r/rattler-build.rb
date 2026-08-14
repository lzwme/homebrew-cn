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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41b03a457781b1ace811d233edd6b8ef079403c3eb564ef5ade9d8144db9046c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3384b787e1a6a67f14f2fed974e15303ae9ae331a059f130330f14cc0335216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9846496e5c721c4a422c5e869b0296a91485a6f8df23d2d5b96f01bb7a521e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "04714da94a1a795670971b20b854831ba732c39279575a6e196a4af51c297300"
    sha256 cellar: :any,                 arm64_linux:   "9d6967c5de93d1ae546c9c1e348edaf74ccaf278804b6fc4ab9a4a32ab8da7d8"
    sha256 cellar: :any,                 x86_64_linux:  "5e5f2cd14cbaf7d827a5a00115ab524971f5fd5f4d1cc79d8a0fae342dc14156"
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