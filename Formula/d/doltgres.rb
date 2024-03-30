class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https:github.comdolthubdoltgresql"
  url "https:github.comdolthubdoltgresqlarchiverefstagsv0.5.0.tar.gz"
  sha256 "51f1ebdfb823b2846720d073c1f10aeb7ad503748f50002b87b8ce7a61115741"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "161da6245b9a87bca480755d60aa6af4542fac9d7b739e64642f7f6f6e1fd15c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fd9a047d9f907ed32b909fb70b7847c1094044c7164e77d1c69293e4044e741"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da5e39a20a701638cac934226a3b6fed854dddb9e244f573fbc4542d48436bdf"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d29b6fdfcea0c2314a1def3be24894f266a0123bcf84160d655d9266349a7cf"
    sha256 cellar: :any_skip_relocation, ventura:        "95415946f9c7dcf2a29c721bc4372417015908d34d9d2303828fc9cc235ca5bb"
    sha256 cellar: :any_skip_relocation, monterey:       "204bf8c862be6c0d858957c1135d124ce1b694abd69ed7f2e5dac1cecd582a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8f43ef19ad871c5cd65ee51a1fe02e5087cb81479498466bbe3b11eadae2364"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test

  def install
    system ".postgresparserbuild.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    fork do
      exec bin"doltgres"
    end
    sleep 5

    psql = Formula["libpq"].opt_bin"psql"
    output = shell_output("#{psql} -h 127.0.0.1 -U doltgres -c 'SELECT DATABASE()' 2>&1", 2)
    assert_match "database \"doltgres\" does not exist", output
  end
end