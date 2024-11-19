class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.31.0.tar.gz"
  sha256 "d6eb02246ae83e4b6d7d89c62867232aabe19613aa66a4888fe29cd96c8a5f31"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d62e588af52994aab445c055247edb8473d736986853dc361986cd483efecc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e43c4d80258d089d961c9cd8c897896eb633fa80c29cd35d4db262cd872812c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9dba3dfb9cfd4f48c1bb4949e853e2bd182cfd40f4fb1144405a45d563e468f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cec9f2b73b20358a74ee8b7202856d5ae5324e2452a8db1fd851c4c6f206d8c6"
    sha256 cellar: :any_skip_relocation, ventura:       "4b100081ada3b6920c43ea481ebbe6fce9dabe449aaab6ad5d58f6ade2993573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7efd0b8c5fb89eaffe7d452d4260ff6493647fb9490c5d2a1d09b17d932fec0"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--features", "tui", *std_cargo_args

    generate_completions_from_executable(bin"rattler-build", "completion", "--shell")
  end

  test do
    (testpath"recipe""recipe.yaml").write <<~YAML
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
    YAML
    system bin"rattler-build", "build", "--recipe", "reciperecipe.yaml"
    assert_predicate testpath"outputnoarchtest-package-0.1.0-buildstring.conda", :exist?

    assert_match version.to_s, shell_output(bin"rattler-build --version")
  end
end