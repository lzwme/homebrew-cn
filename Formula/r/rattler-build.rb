class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.35.8.tar.gz"
  sha256 "8e92c0256ac3ee5978ada10e1ccba961c77226dce8329d46ddfcfa1300c022f8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "404fae329e9aa27fd7e25a2d72a4cecbf002a0de82140070335828c0a91fd988"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd03f369400a0414a531ec31eb19c7f489a3ff9385f1064d362e1623be6c5662"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "716be80609df5b097b33ee2efa241d6c3fbe0c5c4afc962c4aa165f6cf856ac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aa3cb01755d043d27f269ea0c21be72c6040dfb5917fb87b56aae43f7311765"
    sha256 cellar: :any_skip_relocation, ventura:       "de721f7cf9a8bedb2b2d0df9086c523ea4bfdd7a08a60d7b369c9603e1e85a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf61855de7eb7e5a32c147121380e87bac5bb64dc2ed11a748a8a0da83636ed1"
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