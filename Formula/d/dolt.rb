class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.81.2.tar.gz"
  sha256 "2ce83eae4631190a5b8f4dbabf072c05703db09618b72daa7a25c60b220353c9"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2342e0ae65dfa777a1dbfe8ffce11eb9c169bc29b8b5040f2ebda8a55f0dae1f"
    sha256 cellar: :any,                 arm64_sequoia: "8726401ab53939f978b03847b7c734424b33ba30cba13258830a50f6ac869fc5"
    sha256 cellar: :any,                 arm64_sonoma:  "1f785880981601c1eb3d7a95371b2688d29fd521784dd8b64513c65bfed38ac0"
    sha256 cellar: :any,                 sonoma:        "9cd766ccf5995386cee9918d1143c42da6b39f9a6a56e6f584c96c7da87408dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6662e101d8119ae60881b8f026255e74cc26c773efbf75d71bb7dfe833905c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "973096b5bc2e057ce260a9752ca1ce6bf67b3bf14f8116b3417d3ee684875a92"
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