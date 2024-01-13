class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.7.0.tar.gz"
  sha256 "19749281c4686bb520d87615ec8217119ad8ed756c59056ba423ad6ca4135890"
  license "BSD-3-Clause"
  head "https:github.comprefix-devrattler-build.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4cdb456092ea7929b8c306a27df08eb7eca73ffc434fd911397a5aac60d50041"
    sha256 cellar: :any,                 arm64_ventura:  "78320a7eca4dde90a40e1259318bd3d8e61ebcb0b8476abf599c084b907a3ad3"
    sha256 cellar: :any,                 arm64_monterey: "87b51a2f44c7984f9f8d5b4898e8467850cfb0bdb08b2fbf50da194d4b51399f"
    sha256 cellar: :any,                 sonoma:         "e68c94a6beca2e209bb7a59d9c0af8bec6c8ed9bf9b619f5570d8d4bbec7d3fd"
    sha256 cellar: :any,                 ventura:        "7f465034a1abbd0f338a8bb72854a0d524c557186f94b6ba45b8b3d344aa7628"
    sha256 cellar: :any,                 monterey:       "39b09f42feaf66169cbb44175df86617e11f4ab7c2f84db3d87fc3724a580e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "611ccf5d5a8a19a18513c5915a00baa609280b3e91dd8b6a8880aa2eee04f7d3"
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