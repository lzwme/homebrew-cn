class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.12.0.tar.gz"
  sha256 "9936de02ef4660879976c0de3869f7495522564e2fbbf0940402543ddd659bb4"
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
    sha256 cellar: :any,                 arm64_sonoma:   "df387c50c3798f09d07b345dcb9fd421751dea10cd5dc51e36040abb67d1e771"
    sha256 cellar: :any,                 arm64_ventura:  "764dd9c0a885fd3bbe5111236df15d5cdb23794cf303919f47b0c694cba01f6e"
    sha256 cellar: :any,                 arm64_monterey: "0fd11efacdc791aea8eb40681fa83d1a2484b214207ea08f3418953057eb7aa6"
    sha256 cellar: :any,                 sonoma:         "dfbff71dfb9c3852c07ecb915164fd8aee2e198ed0f3879798e3500cbea7620d"
    sha256 cellar: :any,                 ventura:        "26b216ab2524204627f289a7e0ad14118764a75da51e3d8c8f1c8cd7c417d952"
    sha256 cellar: :any,                 monterey:       "b6627e3977fa9edeacf9980c292c14b083160150fd41b8dcbb987557f9f80bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fddde57fd605e53d6f7fea98848c12e081b8e03a2bc0c5573b95fe4bd3699c1"
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