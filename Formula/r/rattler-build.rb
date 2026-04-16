class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.62.1.tar.gz"
  sha256 "6bb76cc850b97dc7c47fdd9b76fc158fe9c0bdfb3df32f3bdcd22a7ba81cc964"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65ab70d1224deb5993a0c329cc37d34239d5e92415bc475998168e5e9644e755"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f9dd290cd860ec0c001b58c0e2b22da69d9acd6d127a95d20ae00f00b64b2b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70a381d331735e42d96613a84b296a526407b62763a1bc4fcd672c0cd5f4367a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7899bb89ec0f123a7026ccec21d6cf74db44ad3f24692ae29a8ba8d28582ce6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7540923ed5d7268f50d94f40ea08775fa646684c96469b894dbefe2948ddc264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2ddc803759bbd943a75a4526729834ad985d55fb5578de35a7e8c2eb4a02684"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

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