class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.79.0.tar.gz"
  sha256 "978687cdf852910790cf46cb020a0cd04ecfa9badfdfecc5c1cef0186aa63d7b"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07be76b5a618100cfb08affc60328b053ed1b5382cbb0e4e1ebcf97491243942"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d559c775c7bf8989813876d28f679cd8e69bdad33ddaed084ca1ae9866dae776"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "805123ef978a5bcff2e42b29439e256f92841292fb5053f51a2bf72b91867ce6"
    sha256 cellar: :any,                 arm64_linux:       "29f34b8020f84027e4623f00e5ae00cf3250d96840a339b0ace591ff6ee0d821"
    sha256 cellar: :any,                 x86_64_linux:      "57034e66dc96c81580c430f8a09371eeb66398ab928e8f1f149a46bfff271a91"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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