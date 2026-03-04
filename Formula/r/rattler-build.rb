class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.58.4.tar.gz"
  sha256 "5011a395a745de0b9881317766c077f3c27923215a6561e3a468b4913899b348"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec96f21febc718f7b9d16f6fb2a9c385237335d06c9f1467e3c626143bed6b44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6820187948c7dc26be0f7f3854da04e54961b342790b5bd6cf5eb40f43fc534c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d81fe7da6e14d1f5dd14a0a394dccdce31567bbc385aa702a6b6ea34c29e63ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "edfe3cce2db8be57cb06a450cc3236c19939c25a4d510a9184a9800d0e7c1582"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4033fa766121cf62f3646f8d50b569b67f253e4104c0606ab2912b4ef9c323b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26b0f16f1b875ab95df55db0c9d638b5e363efcaab670123fd9b79890baa366b"
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
    system "cargo", "install", *std_cargo_args(features: "tui")

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