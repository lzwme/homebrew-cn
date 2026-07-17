class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.69.1.tar.gz"
  sha256 "11390ac055e82514d9aa7a52154036204a18f2ec5cbbe0ca07fd6109b00b08cd"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba59681abc3168e19bbc07fdf3eb83cbe5bdd51437ccf0fe0b2d0c818ede94be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94ec4ee9a248117f8b57a585655dcb48707cc451a2793c722b2c941dd0896a7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "264151eb74ac888af42e51c7c03b765f349eb5c7ed44bfd42fd690da8248de31"
    sha256 cellar: :any_skip_relocation, sonoma:        "b19a2acbfca846703e84b256691cbcd5e28bf5c5f10a46d6723526a6a1af479f"
    sha256 cellar: :any,                 arm64_linux:   "0bc3cbecc90763b108846c0d22fbf8266148e196cd158769dd77343b99134374"
    sha256 cellar: :any,                 x86_64_linux:  "99c7a536ac58a08e379585ac5f4e294e28c93e25282ce6b5a9dc4266e7c088b2"
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