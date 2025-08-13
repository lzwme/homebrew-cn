class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.58.3.tar.gz"
  sha256 "e1d0e13d15a003b21f2db94d3907d2ee7cc701d9cfd453c92a89b7adefd6d737"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "218671be60ae4ca3e12cf27462ef6a57ae63dda87d3580f2b2dc15ccfecf6c04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "262ba27972db570a579d28c8b0f0f1a15aa44da1cf3ed2a59849d982fe892d72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "132e11517cd2478e6f86df9e697b07c7372fe07775188f2c07fa45793bd9d00b"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa1055ebd69d276ebf889b8fe09dc01f8086cad09664600fa678ae78987354f6"
    sha256 cellar: :any_skip_relocation, ventura:       "9d5bd2e125e63d8f3f816c8c3ccc52a99672e5249098b682b1cb19c881b9e286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "508d8ef2de3732fe84f4e36e8fa42e7aee20e25ae24c425df01bd6b2edad0330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29f4111ec9f9b1918cf7cd73c2db03ec4a5f6b6296be8cc30b001f8f1a92d4a4"
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