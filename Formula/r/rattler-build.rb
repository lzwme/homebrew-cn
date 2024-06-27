class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https:github.comprefix-devrattler-build"
  url "https:github.comprefix-devrattler-buildarchiverefstagsv0.18.1.tar.gz"
  sha256 "d351851282cf16048e1180a534441d694a8d89ad3a6302e45b0de3430623e9d7"
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
    sha256 cellar: :any,                 arm64_sonoma:   "9a2f7c2e250cded86bdb2ba8806ddb93ca62955864132bd564e054b369146ba6"
    sha256 cellar: :any,                 arm64_ventura:  "4e6d84acb432c69ce0566b8a88bb877a2fb321a9d37d65bbcd5446b081701cc1"
    sha256 cellar: :any,                 arm64_monterey: "e6126a32dd842997bf6e6f03287d9b52585dfe6e4452bb9ef507674660380b3c"
    sha256 cellar: :any,                 sonoma:         "79ea5be05857e785b856b3cf61ce10adf84ea43401afd4ba5b9e5675e0159e15"
    sha256 cellar: :any,                 ventura:        "2b8b68822b1d91c73119b310e47922f780a8fbfc67cffd5d8a25f1d34d1a3dd7"
    sha256 cellar: :any,                 monterey:       "e111b2616d9599c7e72a57d025ed357dfaf9c7c698c82a6d84a46d3c712f9adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1854b771628a530ab22e1ab30b865fbe3fac9e3e5530c99d05eae9cd907d6189"
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