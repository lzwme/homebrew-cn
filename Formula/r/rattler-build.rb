class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://ghfast.top/https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.62.2.tar.gz"
  sha256 "447dec93abb781ac3d8d5b3e8d6e88dad757e5af128cb767dfa86c63d6c63ea0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80b7e6113146eff8d895d65d9bca8083f2506f401f684ad493f321cc16824210"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b80cd48d6e9b50035a7b96db6f33609837494a0f3b4fea7574d6d9b3898c82b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf9c91d6b2ff274b8f079c9a5ed082ebe3e9981a3d5ab8d3fce977d107b0fe94"
    sha256 cellar: :any_skip_relocation, sonoma:        "658b78b6083c50227baf51454d9440bf0a7af0f474edd2bd4c6887b97949b87e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fb4df291ed3cb8ad3e397ed35701e424729948ebe8088ae049df0b4fe1e5284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a967cbeb99eb03b5090aec33c88a464d7080657bfc75af9e8d81081015338c39"
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