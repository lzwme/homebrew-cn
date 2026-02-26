class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "3a0c2a266a1e1572e5e55619f02718627c513a49e44c1df8b54675b1e5bb9d49"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71d4adbecc45f6c7b378ae9d16af33cf1ecb696d6c3ee26da6b6f5cde04e1534"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf16a7ba8f51f3a2f565e3bd96e7825a16d50f15971cfa728bf596a2de8107e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdabcc1e083856ca091f20c63cf1c465efb53276611f8a14eb137b94cb73ad6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3ea79a310ab736e453ef64e9d8027ad177e9ac7a5ccecfed79051277415e1d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "736b317b212d8e5f1f2a12d9f3037559527e5663fb1329a7a4265e7ceb31c2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e4cceb06130367f4135455228e297994a477f792aaeaff121f6dd9984177892"
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