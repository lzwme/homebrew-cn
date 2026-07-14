class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v14.15.tar.gz"
  sha256 "411af89ada07bc5ba84c5690d533eb13d276b12e7ed1b7e9717cab14fccef1bd"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5552d48fd0e0454fc5338263d1e42d43c8ae938af8d3a34cf16549304062590d"
    sha256 cellar: :any, arm64_sequoia: "14807e11600ad1b6650f7d138005f482efa3dd2a536e1b44ce2e75d2ff188e1e"
    sha256 cellar: :any, arm64_sonoma:  "5801155ceb66f7b125bcd2b6f28790d3f954158a3c68286e6ab2d077bb735750"
    sha256 cellar: :any, sonoma:        "75d938c35ebaad4e797db82c281fb86c5d6174fd979172fd968366ef0a5c6135"
    sha256 cellar: :any, arm64_linux:   "e5530f4b070ef023df14ec1ed6f3e4344c750f1f7f585581c838992ca945e424"
    sha256 cellar: :any, x86_64_linux:  "400c837c06719a054073afa75240e289b903e852c0ec2de2135415c99600b4ad"
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