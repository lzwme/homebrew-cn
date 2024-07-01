class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.18.1.tar.gz"
  sha256 "d351851282cf16048e1180a534441d694a8d89ad3a6302e45b0de3430623e9d7"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comprefix-devrattler-build.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f80dade149c52840b520ce740522a4d0070ce31cb5d7a2d59fec4d9d496ee519"
    sha256 cellar: :any,                 arm64_ventura:  "5bfe8ef92871aca8ce2ded075292e00e922b6107745c16f2a688fd36ad317982"
    sha256 cellar: :any,                 arm64_monterey: "dd84214526c0b8867f207c6435fdf45f0dad140978d6fba1ed2adc6604f37b7f"
    sha256 cellar: :any,                 sonoma:         "e16378a687c6b8ad7bd0f9bc0c3287770abe77c1abe883c118cfbb0fa451fd47"
    sha256 cellar: :any,                 ventura:        "9e7c274a534193bb9b68b966fd5dc928f09ff34a77b912be50eb402b7826378a"
    sha256 cellar: :any,                 monterey:       "817e60b8d04d42468befe122562a3e043e9dba05779f80b03a7679c9193eb335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3316a647d573e52f0a4b59eab59ecf087d18df52d32606ae8f1b1b767bd21bd"
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