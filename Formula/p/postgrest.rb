class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v14.12.tar.gz"
  sha256 "44728a5909511cdeadfffa1af4a5eb091c7a21c5edbc95993469d87e54396ae2"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3d36359a7493f203d2a40a0cf621fc24a45fb1dfaa36687c6ebc4ade7923c1b9"
    sha256 cellar: :any,                 arm64_sequoia: "a1f1ab204b6afe1ad1c0c1f24a4818d3748e521aad1a05ba2ae43048e9693a02"
    sha256 cellar: :any,                 arm64_sonoma:  "126c0c8e41cd0ba67e73c8c10ec658153d50103375aca29fb366c12b8149e29e"
    sha256 cellar: :any,                 sonoma:        "7cdcc3a9fefbff29cd6f843edcff6acdf5119cec6932e13431fc319acabebb4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb327b540fa268eca8d83d064b7bbc6196018b23098ea35fce268057335a7ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46897db591aab909dc4890cf6629b0f504fd261db84e7a2a7212bfe27eaed55a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build
  depends_on "gmp"
  depends_on "libpq"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build with GHC >= 9.10
    args = ["--allow-newer=base,fuzzyset:text"]
    # Workaround for https://github.com/fimad/prometheus-haskell/issues/82
    args << "--constraint=data-sketches<0.4"
    # Workaround for newer crypton not working with memory
    args << "--constraint=crypton<1.1"

    system "cabal", "v2-update"
    system "cabal", "v2-install", "--ignore-project", *args, *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}/postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}/postgrest --version")
  end
end