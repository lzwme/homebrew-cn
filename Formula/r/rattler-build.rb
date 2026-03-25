class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.61.2.tar.gz"
  sha256 "edc38d11578369740fd8ed5746d137a45c0b7d026bfd06c1a3c694bfed155d01"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6eb4032acd6d0d8d3bc0cf2cefc2661d3f77970a8a8915d9e881f03e20a0ae7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e102bb7e1817a5f5733407134b601c230743637b843dcc4fe9e8c84ae391962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ae76ad888ea7290a9083842b0809f9d7c49fcb5f115f6b25d16dbd27384797c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9fb859410b1fa794fbc6b49e6d1dc7709fd714647575ac1ec16e9f49a2414db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddce8f308bf0e56ac9c71fef167cb1e12419d208fbbe5a8b4197e6d9ff81855f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4411ebafa1a69ad82788f464bdacd818394bf0d470c9cc56cae8021939b8b004"
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