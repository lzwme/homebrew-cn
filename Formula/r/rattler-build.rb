class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.66.1.tar.gz"
  sha256 "1ea54bf5119dac0d4a2a3d9821f7cf620c0d8b39a8646894cd8515846e86dc64"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29157312e5912cc76c381719506e91a7a6151b08554be2669567c78c3a3701c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a24da52e6b261f6970031d445fe9de69784a5c959b4ef6fd08efaa9866909a31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b77900a53ed4bec8731b43f13aa5e0d8e665fc5fe2f9ff7f6c42bf75b914eac3"
    sha256 cellar: :any_skip_relocation, sonoma:        "77dedc9d2556f7908c069f05ff80046d2951f6fc55121c48e8139974a2e2d099"
    sha256 cellar: :any,                 arm64_linux:   "faef040c0f4f13d1c9f34a3a6a40017b9d8cd2dbdaf5596bdce7f642f5d6faa8"
    sha256 cellar: :any,                 x86_64_linux:  "24fc05004761ba80c9828cf8980bb6a4a24b60a1db1fc048eab969993086db3f"
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