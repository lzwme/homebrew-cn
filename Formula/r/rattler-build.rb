class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.14.1.tar.gz"
  sha256 "6bdba8ca2a875b52d2f6aedf1c8af133790bd62ec2545470bf48c682d48717f3"
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
    sha256 cellar: :any,                 arm64_sonoma:   "b3e6241601a9621f137c0bc2677b0a49e1e860483fa01624e8707501e4bb6a1f"
    sha256 cellar: :any,                 arm64_ventura:  "1e5cac37602b70239538301e784a918c99d1680fb2d74ad0788ca6bfb29982c5"
    sha256 cellar: :any,                 arm64_monterey: "91307e6643c7498deec120227600a5e811c6b6508678101dd4859e13bf01cfc3"
    sha256 cellar: :any,                 sonoma:         "00202eb06a7fc3645c24be0fc92b70046db452e92158dbce211d21bd33f54906"
    sha256 cellar: :any,                 ventura:        "ef6bcf2c9016c37151ab16311834acc04f31077e10f2f459c19acc4f7035db13"
    sha256 cellar: :any,                 monterey:       "538140aad87f7e9902b1beccf49b0f976c496db8a7e7277f44d12f34d6e117af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a2407d038a811afe611279cd7c3177d07cccbcfb7786370adcdd5a35e5c3fae"
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
    system bin"rattler-build", "build", "--recipe", "reciperecipe.yaml"
    assert_predicate testpath"outputnoarchtest-package-0.1.0-buildstring.conda", :exist?

    assert_match version.to_s, shell_output(bin"rattler-build --version")
  end
end