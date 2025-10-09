class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "f84b57e4c7cb4e19ae31f487d2d4505ed9ff2ac08d61c75e68800df5e506baaa"
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
    sha256 cellar: :any,                 arm64_tahoe:   "5d77f500f3818ae010f52b64840f0b46b3601e8def24794b08647bb0d0e847d7"
    sha256 cellar: :any,                 arm64_sequoia: "f0896bafd69e1cd86bb3aea192a8210cf9c4aeb671fed150560918fadf5e1872"
    sha256 cellar: :any,                 arm64_sonoma:  "dc34455e9c537529e78b3d5d49eb531adc60a32abdf817cea246c633c1a07b10"
    sha256 cellar: :any,                 sonoma:        "f8e00adb809141bb7e690f06edf4520c6448f9a1d21436a20f79de1fdee3f484"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cadcc154f6f40800219bc1073a9f37efa9ef99898d56a43627aded725900d721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b1c36b7572e3e4f71a87f48454ce56663ff806b5b042dbd6ef36cb8270079d7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--features", "tui", *std_cargo_args

    generate_completions_from_executable(bin/"rattler-build", "completion", "--shell")
  end

  test do
    (testpath/"recipe"/"recipe.yaml").write <<~YAML
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