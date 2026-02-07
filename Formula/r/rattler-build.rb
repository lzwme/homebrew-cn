class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.57.2.tar.gz"
  sha256 "a66c2ddddda9ad57240f5b01b1a3ee71b762400ea3c1b2ec462ee103a130d5be"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "692021b110cc783a8c239621faf55960d2765e5237d8afc46c5ea14aab2f95ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c593857d65c54345c380563242c6b57c1fb56013ac80ac01a0a0d688a5c37308"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d762a8f35032a8dfaee16dcd46498f2cc72019a2f441f5a854712b683a3023"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d89efef37878dbc5c6fd864034de2bbb64d8f00d99edbe6f851280f39f6d5ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d75640b071f39d46f852c92d68a05cb7dfdd47da4a211ebfe94ed242413c0f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2193b4d92d735160215e91cf004f2ada85a64434a924f8690b5f2be990d3c277"
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