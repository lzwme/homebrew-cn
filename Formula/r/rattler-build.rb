class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.8.1.tar.gz"
  sha256 "5d32d165043b09b2daad0a038098e44694ec9c07d9b4dc37828e6df27cb70df2"
  license "BSD-3-Clause"
  head "https:github.comprefix-devrattler-build.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "45ef1125f061bfe5f4abb7e9468465163da0b3ee9390c8ffa2ab4297c6e87e9a"
    sha256 cellar: :any,                 arm64_ventura:  "cbd73e39a5d16dfc04a1b717ffffe822bd51a67a6788d0d447c4032f5eaeec9e"
    sha256 cellar: :any,                 arm64_monterey: "68f92ec81692857c9974bb1b5e4b7a4a1c70b3f6084269e9410c1b0166169295"
    sha256 cellar: :any,                 sonoma:         "2bd9647d82a5f74e09e22664f9249d68d2c9db9b115891fc886b4a0f16882b34"
    sha256 cellar: :any,                 ventura:        "01ce8ad9fa24b7205cf9ddb567eb26e01562be8332ba3ae8f4d22be86d088fee"
    sha256 cellar: :any,                 monterey:       "32a27aa38577b097501257d7cf1da7b45388f0e2ea8da69ab89c83c69e068cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dadab299ffb13b31f7b068481945b8d42492465ebcd8d478ac3d50670ce3322"
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