class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.59.8.tar.gz"
  sha256 "3281646dfccf493d2712d890a6f1ed85dd00d3d4a589551abe6f89027d14fbd0"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7291bc58f42a951d58b11099af42a812ada4bdd925631da8ee3b0db2445cab0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "784f397a39ca4f587c900d88cb665b24d7e62002a6132821c36a63937bb67e12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bbde24ddde762a58ab34729b60f2b74395b79c434ff0daa5a05d462899ec084"
    sha256 cellar: :any_skip_relocation, sonoma:        "98092ae86e54f9f64d967b156caeac439cb9d0b19bb826ad6553ecc3ce14e006"
    sha256 cellar: :any_skip_relocation, ventura:       "ba40afccd2e9588250af4107dd51b5adb73a6ae5339b0a9fd82ac38907925332"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bb8bcb155a72527b1ed52839500d8dc36c97a674fb11c7a500c1f039d3576b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f0d3070fb7765e2b6900c550129e9bc8b78c57bfb99673b4a953d37f93f0211"
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