class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.37.0.tar.gz"
  sha256 "a77482fa8b907e91970cab8f0d4bf1e105fd0a2b0521af91dd830b3832ce57a4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c731cc92e87284cd08bc18cb27e4d62e453f25f1151d57a82eabe6cbe5c4586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab04fbff0333cfecada232b8395c0632a6ac62a3ed4b726136d23909d61a1623"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf574e756a24d04a434dac929ea905aa7c7f292e6948eabd93bc29baef060f6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "84fe1f26aaa70ccca2a5f6766c009d1d421ca80910c90f9ea1d1fc6d95c5fd26"
    sha256 cellar: :any_skip_relocation, ventura:       "bcceec84345ed7bc06a19cafbb8bf6db1e5241525669e8db511489d66ac4fdc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a5f490575334811f45858d1e69ba687820f1594b347d30f4fe8c949f85dfb14"
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