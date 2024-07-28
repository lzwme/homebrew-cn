class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https:github.comPostgRESTpostgrest"
  url "https:github.comPostgRESTpostgrestarchiverefstagsv12.2.2.tar.gz"
  sha256 "dadd6adfeb5cde85b66efe330c6c06ff92a5f7d550a7cdc5223f9b9014aa7b6f"
  license "MIT"
  head "https:github.comPostgRESTpostgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c158053a9b1bb01485be62f1721c3c056a2e91173281634163a96dca5d651022"
    sha256 cellar: :any,                 arm64_ventura:  "4e0a0c9b1ce832caa4f625c9b6bb80d865f777cd59515dae740928b432289b7e"
    sha256 cellar: :any,                 arm64_monterey: "7a5e6327e5a858e4f94599b94d261079d1c13d72fe09d77d251dda45507c2fc4"
    sha256 cellar: :any,                 sonoma:         "b8f8500a41f91970c16fec56d1e154658c2f2348c439ca913f5e7b14a433a802"
    sha256 cellar: :any,                 ventura:        "c2f686401fb4a5518eee68f395cc7cb59e172c3051a1204f406d9b2a9e6444c0"
    sha256 cellar: :any,                 monterey:       "d1730bc658c4c3f499fbcd16d415a26d9b6e5c52773c84990e8690a9942674a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5c174942d0184c4ae7fc1d124cbd882bfa6f8f1d49b2ea09d724a5216053d41"
  end

  depends_on "ghc@9.6" => :build
  depends_on "haskell-stack" => :build
  depends_on "libpq"

  def install
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
  end

  test do
    output = shell_output("#{bin}postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}postgrest --version")
  end
end