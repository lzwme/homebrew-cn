class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:rattler.build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.33.1.tar.gz"
  sha256 "08f61d0e3998872881129913ac821914cfb9b470e571c5645409eaf7493cdf12"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18637e5b5ede17586f4e0ed59a05aaaffb1db086bafa6bc3c7a43f39e21ec3d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08f30b07595b70dedf7abdc2e0eb8b8bd1a68c375248eb97b88ddb8b4d194c21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f14823549b751fc26e999bbbf59f80aa53ec416145e544ae30281a417a94b4a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f7f60a6a514f751ebd5445b29a3228c5808e33aed00805672c8925fcb5e403c"
    sha256 cellar: :any_skip_relocation, ventura:       "1ac0888adc549fd0c4052bb3a32409817d6e26263f52c0c56563706e10a52ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9c55eae473ee3e17844666c3198614230e1c6117f6f88a132ec19aeed68870"
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