class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.16.1.tar.gz"
  sha256 "64f5d4e3ef9f6c069ef2057b5302dac36d0f1cbafee586de35c723b159411345"
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
    sha256 cellar: :any,                 arm64_sonoma:   "9a85bb7a7c64e9d8bfb76f00434e2ba8e78102ad347b6220ccbeda74802780c2"
    sha256 cellar: :any,                 arm64_ventura:  "95ea12761ecbebd0484442da8e7d9c054f31d41920c0bb8fd7f7f836a2f244d3"
    sha256 cellar: :any,                 arm64_monterey: "c5a8590a65ef760cacc39679c480b2b1c93ab06ac49199637450dd0e8069e966"
    sha256 cellar: :any,                 sonoma:         "644cde5af3e4fe73ca0fbd45289287070c63ee5feb29547b0ccd38f6a324233a"
    sha256 cellar: :any,                 ventura:        "7a008cacaecf5063ad9b93b15ec3a46bdd91a9903e3eb99b9e2835f024607669"
    sha256 cellar: :any,                 monterey:       "868cccaf998da9af12871f205b830e95e52da3f8208bc0384377f4938bdc2e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b68f60c28e583defed6f3df399861d01338dacf9fa92d9e0e523d9a4e47651eb"
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