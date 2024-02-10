class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.9.0.tar.gz"
  sha256 "10f364e2eeb402f27c76e16f7bf75e2aef8f869dcb02a70584e0bc558f3838b8"
  license "BSD-3-Clause"
  head "https:github.comprefix-devrattler-build.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fcec2484b94dc2ce536804cad3d0b6f4c06bd21d3415955426d174fbf967627d"
    sha256 cellar: :any,                 arm64_ventura:  "8791190bfa7ecb9253ce4556a6179316f12293bae434953ad4061b43c9f4bf1c"
    sha256 cellar: :any,                 arm64_monterey: "5074457d64f837151d150e994e212ac6d003d5b41c55ed6545bd6c02c0f19e51"
    sha256 cellar: :any,                 sonoma:         "b842d6ba609ce7ea6332eafe4be310ed68496940b0c3f49cb7c2336e5b2ad554"
    sha256 cellar: :any,                 ventura:        "48de4ebbb3fb3c153ea5ba98f1bc3b7a3473eb6226e407564012803a77219205"
    sha256 cellar: :any,                 monterey:       "0bf2d3d6abd3dea9547f9856f31ce2ebb1dfe72f83848fc2c5a83c0a3f189f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "175923f5f717fe3af4e61b38169e8bc823c54f94a71307a7638180edf232b881"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"rattler-build", "completion", "--shell")
  end

  test do
    assert_equal "rattler-build #{version}", shell_output("#{bin}rattler-build --version").strip
    (testpath"recipe""recipe.yaml").write <<~EOS
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
    EOS
    system "#{bin}rattler-build", "build", "--recipe", "reciperecipe.yaml"
    assert_path_exists testpath"output""noarch""test-package-0.1.0-buildstring.tar.bz2"
  end
end