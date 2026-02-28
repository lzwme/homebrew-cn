class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.58.2.tar.gz"
  sha256 "8fc0b68b475d7aebd3978aaf0824479bcc640120c4a2104e0e6999e803910b54"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b05fb5170137d2b88a0d25b915bae753c886401066c1f8fb60684dc741093f5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f2b756fc0546bbf534ba08653bd5f784db2aaa21081952aa5aae23728fb6a6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a9415612581b681a97a946a684a0a408215708b43d6ac11e6037b2df6492532"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f7159eb1ebf98e3ce97315d17bef97de8fabeebd4bc94127d5fa6a5cd9069de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a5e7f2d7d391f3b4560072e83af65410eec182d764d23368dd276dc37bfe419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b380116c938001a6ed5c662bf0b9a65ff1163459896fff4e4c27d8ef4a1ec382"
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