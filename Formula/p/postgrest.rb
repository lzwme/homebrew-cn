class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://ghfast.top/https://github.com/PostgREST/postgrest/archive/refs/tags/v14.4.tar.gz"
  sha256 "a68d01b469b653420c579dac184a6dd85e6715a37996864dc0988e2ce73e14f2"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e60d66cc3c7b206b69cc5769d46ed88843ce80f3adf88ef4a50b68f39db8a867"
    sha256 cellar: :any,                 arm64_sequoia: "8e5204b14b3e8f289eae4b9806b70ee2e8f27459808c183e55c536faaf0839be"
    sha256 cellar: :any,                 arm64_sonoma:  "58f53949198c5ba909dd8f4047e47d5a5368a669e723c079e6a3215e26b294ec"
    sha256 cellar: :any,                 sonoma:        "3fc62a418ff3b53e84b8d281969de2b371083d6e0d6b19f0885d45469973f7ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be29b4ceab0e6af41517426e2a329cd4feb826d674b39f5c65f814476e2a9aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dabfd19f5a232a2e1cf14147d9c52c107568471b32ada76332a6a8aaa4709626"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build
  depends_on "gmp"
  depends_on "libpq"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    # Workaround to build with GHC >= 9.10
    args = ["--allow-newer=base,fuzzyset:text"]

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