class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "f71eed5316c2677fa0a905a0b6d262b32480baf7762b5214397e5f88f7d744a7"
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
    sha256 cellar: :any,                 arm64_sequoia: "44ea57ab3aa0cc2cf71710c76a2ad89db175bb132bc5742ed0241a3b89ddff4e"
    sha256 cellar: :any,                 arm64_sonoma:  "7d0ff87d483988499e1436c77527fbb7d865e562b1056c321bd9fed5bc0ee30e"
    sha256 cellar: :any,                 arm64_ventura: "85c5716316543dac551b7a062be1122189821ae7d4fbc1fbe07bf83218fc6a38"
    sha256 cellar: :any,                 sonoma:        "f37127937884f6bc76d789b57aa8b50bb600ef947e111123b3369ff0cc0dcebb"
    sha256 cellar: :any,                 ventura:       "7d8495de7f3ce8ef6be7123653a61c728270e91fc12b4e2c65ac55501a44ec36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57b83030c15974906c41874ddcb0afb4250da0e79b0a5aae38c0d6e8c7cbe033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2a671b96aa08815b263f3192c8d44a3066ecb4b3d18d52f36a328747086521f"
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