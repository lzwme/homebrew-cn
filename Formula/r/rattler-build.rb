class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.22.0.tar.gz"
  sha256 "254a8c8defb7196c3a29fad7eec6a9c27c9df14f77bbe6bd9e0efef29885ca88"
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
    sha256 cellar: :any,                 arm64_sequoia: "4829fee914e8808a9c9b9fb59737fe1a2c6ce3fbc6e28687ad207faf23889567"
    sha256 cellar: :any,                 arm64_sonoma:  "25f836da13a37657218797a702ce1523c18afb358f412366db9b802e14baf90f"
    sha256 cellar: :any,                 arm64_ventura: "b14159d4d4673db80f3d0d7f1bf0e9285440debfcc2ff44ab33513953977463f"
    sha256 cellar: :any,                 sonoma:        "3418ae99efb337b64fd1067a2f7b2da503f063729bb207914fabb9334ca32424"
    sha256 cellar: :any,                 ventura:       "52311171179b9070a7d4bd1558a38749a346aa6a20b4aa86b441254f0729a49a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47ab1d2b49293850dcb66e0ce2c3008d0cef9fe8554664668f6bf41505fa5e28"
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