class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.59.9.tar.gz"
  sha256 "4fcd588f6736c237c93da026101ad85912bca93bf982361c5a010ba2c3aeb8a7"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51ea9a5aaccc2b75973a46318accad60dfa911938a417c04ad21f9cc2153e32c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aad84eff248c4180fed8b0e82341eedaef5991d37d9a08dbe08a7c8e43b31a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dc7cc1d0dc307d2faa88310dcb030fb4f1c6704a1a955ebb8c105e9024e8bb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8a7078e09424a37e0bd68077bcc6fc408a407beacbdeb58da8b353e25f38e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0802809d27a8c59a83a042f45e83482677c16a20d915e531ef8c59cbe5b7dbc"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
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