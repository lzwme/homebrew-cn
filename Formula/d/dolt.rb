class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.83.2.tar.gz"
  sha256 "ab07003157bb17fb5fe37399d43cd0cdf4f517f7f0f1669a50e731800221650c"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9aee604ac6d22e2e57b21957f0987762d24e31e12d912fe4d32de976de664230"
    sha256 cellar: :any,                 arm64_sequoia: "e49d00709ed79ce7745cf1369e88b8839614f710fa8b22c4dfd043075f454f2d"
    sha256 cellar: :any,                 arm64_sonoma:  "5e0b392dc76d95f4cb7963bda59480ff9bdcebdbc347045fffab609961313028"
    sha256 cellar: :any,                 sonoma:        "5720b63f2af730b437d6793ad53b0f43fd8c3a5622a0c7a4997ee5ea03ea5784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87a049d5a33d3e5b8a0f04f1a4e2e853ce2858ba14baa02bdc8a710f5f6ef8c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fd2235c947f2daacb07def642797b66abcf226a3bc44292a095c4eb94deebea"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end