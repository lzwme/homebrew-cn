class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.54.0.tar.gz"
  sha256 "a2f599c9ca710c0a8892a8396d68803a5f39af393e58d7ac28df1ef5ca0c9c6f"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fa98c72a4ba02abecbb3a0ca73c31a88ebb8d374d7d07687c27cd10e36f30f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4db380edf2fa6cd1be19bbbeb6db23ffca8f9dbfb50f1edb9e60082c87fcac57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39c929ebefa4ae5ee0ea7015af295bf1469d058183693e0903b5aa2d8197b902"
    sha256 cellar: :any_skip_relocation, sonoma:        "692a071de1ecd6bda2a1d3ce9c36d16d9a82827d18e466ef981ee2073dd1eebe"
    sha256 cellar: :any_skip_relocation, ventura:       "81cb05d0e1da768bb25d66b9b9ff1c85738ebd0f668a0559f760fd909c534924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74593d1ece68cd3de5ae329fb5474354a9e26f97f38447deead10ff6f2ed035e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baac13206fd21a10b7782b0f26019dc979b3c0f99f42c8e4f7dd426f78f385b5"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddolt"
    end
  end

  def post_install
    (var"log").mkpath unless (var"log").exist?
    (var"dolt").mkpath
  end

  service do
    run [opt_bin"dolt", "sql-server"]
    keep_alive true
    log_path var"logdolt.log"
    error_log_path var"logdolt.error.log"
    working_dir var"dolt"
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin"dolt", "init", "--name", "test", "--email", "test"
      system bin"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}dolt sql -q 'show tables'")
    end
  end
end