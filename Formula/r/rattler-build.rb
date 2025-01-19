class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.35.5.tar.gz"
  sha256 "ead98140911288500593b6e5385c41ab1fff0249d041c43281a40acc7b7aac15"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3492b67bca8ea3c3e8c9a30f2bbc6468ea8360062e64865a14490e84cfd8a1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89657cbd96f6ff1bd3e1438aa6473ff915fa37accd075dc12ab403a324cc10d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2915731e26d66a81f3705646aa3af7354568efcecdd502f5a0b47a9ee2c12d0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed434c9ac31479a35036bf3d6c9d61bdadbad79e8bea15a59cec82f9274cf3be"
    sha256 cellar: :any_skip_relocation, ventura:       "3f5b663b8dfa8dbf7c5c39f8a7940a5a320530a4a5860426f10cc47dcb11a63d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e707565ddb1d5b91984765b38ba3d3aaba63e802f7420d698674c7fd6d1421f0"
  end

  depends_on "pkgconf" => :build
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
    assert_path_exists testpath"outputnoarchtest-package-0.1.0-buildstring.conda"

    assert_match version.to_s, shell_output(bin"rattler-build --version")
  end
end