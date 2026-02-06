class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "cdc4a8a49b5accd107baffc64ee30be91eccfde995f159217605bf80b6c8854b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "033f3caf44822780d682e1146cebb6afe65aa368fae42e52d423dcb66fc33ad5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00695f8626604fb632783dd35907031a1fc46c5b1cacb1dbcebe35830e2be7b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e04cd40eaeafc877ccbac02ca10bccae9de62c7643187933980acf1c365ddb9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad9c763fc9de892c35e7a1012f276d72ace030537e30db9b95801a5dc62ded7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af5fc1ed8ebadc4d56797c26011fb492b6ed72fd84570e89f44978ec8b5bd403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6afa2317f9e84a5744f9cf93bcf770cb25052d895ced3bc724e392b3b6a40bf4"
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