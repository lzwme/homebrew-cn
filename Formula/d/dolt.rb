class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "f35979ef1b8055b1cd22618285886aa1d95da39ef92293d37049bc8178a9ca5b"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "88f331f2c9593d301a2d517128a4fcb24a58feb392f27bbf707419a4b62e50b3"
    sha256 cellar: :any, arm64_sequoia: "6a29d0dbf9b99020c7fa898514df7ba4beb514b61a56a2626f745a311a8eb84b"
    sha256 cellar: :any, arm64_sonoma:  "fdd527e5294d26adf61a8a08bb843a1acf24d1608e080240ef5c218e26a2160a"
    sha256 cellar: :any, sonoma:        "0db62cada2b07fb3b81a2a5958bff0b48b1deee6be01d1ef6b0f3854f886b1f2"
    sha256 cellar: :any, arm64_linux:   "dad0749560316ac800a38015343edbde0093c90d3252be1296529fc38296506e"
    sha256 cellar: :any, x86_64_linux:  "2900333355008a4851d350425987d36f0487e60625ad23eb103d7d7fdc311abb"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (etc/"dolt").mkpath
    touch etc/"dolt/config.yaml"
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
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