class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.18.2.tar.gz"
  sha256 "f7d9030f54187d68f23c880c8737dd5b722d098a60de9fa2be4697495312b742"
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
    sha256 cellar: :any,                 arm64_sonoma:   "71f588063c8ddfd913f145001c269d4a7775e5b16914cf2d4b72c3440d8d9f35"
    sha256 cellar: :any,                 arm64_ventura:  "06052f332a3ed29ddc9c0d0052ea4d96391637a3498f98e44ee9164e485af36e"
    sha256 cellar: :any,                 arm64_monterey: "246a2672529c47ce64bf21a0cb824675a7a0d665361bc478fa140b34ade40d49"
    sha256 cellar: :any,                 sonoma:         "8e1c18d92d4b9785edeaeb5fec17583ba84b0a21583b9eb155d6898d492cb24c"
    sha256 cellar: :any,                 ventura:        "b360e9ef5d6792a5693fe8a482b83995eda52243745f8e9ecdb0acad31c40b14"
    sha256 cellar: :any,                 monterey:       "deddb9feba88523d60bd9b2fb916c80a174a2775898d251daf5218f635ea60e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c52c5d9e94fdf1307b15b7fb8cf8fd57449efd64578ac3a0fa0c09e6b1fd95d"
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