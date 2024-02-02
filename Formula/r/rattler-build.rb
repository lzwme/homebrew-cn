class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.8.0.tar.gz"
  sha256 "9a3b2c7a173d0a2e4e869819c7fc6ba3a62ef20b4993d04d9a45a7ae657613ee"
  license "BSD-3-Clause"
  head "https:github.comprefix-devrattler-build.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d238a9ab93d4b1a1f9dd65b678268ac02a08a0c7174c5760cb929a1d0fee4d6d"
    sha256 cellar: :any,                 arm64_ventura:  "a603665140f34c865621c55fcaf6673db888adfe99e53122c864eb9934c6d3d5"
    sha256 cellar: :any,                 arm64_monterey: "42a5b5555f43dd8483e4e55a3910aa77e396eaf5b708692eb625ab2cfbe70081"
    sha256 cellar: :any,                 sonoma:         "9b388de82f9494d9417d1fa7bdd911174de1a820cb82894b37417e6ee2a00aeb"
    sha256 cellar: :any,                 ventura:        "2dcd5f054b9406abfe93be7d0928b97dba63df86e7743136c3298a01588eba10"
    sha256 cellar: :any,                 monterey:       "99ad04f820a278db029afe8e85312883b700187e0d01811e53deb084cb2dde16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbec774c52d360f22e158ed15f3ad8b15793eb1c3c3a55e1c1dbeb644310e660"
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