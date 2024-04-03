class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.14.0.tar.gz"
  sha256 "f3abad378c280670ede09b19c26c1bc6e76314978251def5891752ff8d7f7600"
  license "BSD-3-Clause"
  head "https:github.comprefix-devrattler-build.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dbc97a9fc56a1a010e9f06d562ff33f4d2ed1ca9fe284acef2998bf2ce6ec48d"
    sha256 cellar: :any,                 arm64_ventura:  "079ed69091582e635aee48c55a3451347a3f344ba10da8ecd2471b3cbc975764"
    sha256 cellar: :any,                 arm64_monterey: "6193681faed8a2dd238d3590787cbcde284a4fa663672f992fdf5e77aa6d1296"
    sha256 cellar: :any,                 sonoma:         "f5db0b4c3b92be7112cb98f4e6392b91af5a12426c945333f0f192483e4baecd"
    sha256 cellar: :any,                 ventura:        "f3ec40f90d046614f4180f6e7f982f0596b69340c5b20ff45c8f80bd5f32a32e"
    sha256 cellar: :any,                 monterey:       "a1574a9eff400210e21008cec32f0b667beb4a990a9a01c3c911265ac91ca65f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac5ebcc78021f4ba4b70a51aed16300c6b60ba2c552dae36a3d8b2befda423e0"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"rattler-build", "completion", "--shell")
  end

  test do
    (testpath"recipe""recipe.yaml").write <<~EOS
      package:
        name: test-package
        version: '0.1.0'

      build:
        noarch: generic
        string: buildstring
        script:
          - mkdir -p "$PREFIXbin"
          - echo "echo Hello World!" >> "$PREFIXbinhello"
          - chmod +x "$PREFIXbinhello"

      requirements:
        run:
          - python

      tests:
        - script:
          - test -f "$PREFIXbinhello"
          - hello | grep "Hello World!"
    EOS
    system bin"rattler-build", "build", "--recipe", "reciperecipe.yaml"
    assert_predicate testpath"outputnoarchtest-package-0.1.0-buildstring.conda", :exist?

    assert_match version.to_s, shell_output(bin"rattler-build --version")
  end
end