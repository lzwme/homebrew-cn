class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.59.6.tar.gz"
  sha256 "3d96f8dd006967ea26a4e27f00309cbd6ae99e875c0faa625dd4ca7108d5b70f"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17d9ac70b52adaa46b2cbcf33ff5d18c57fb7bc080de86fb2c11d048d57e455c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4848253af88602df032296c4fb680e4f97ecccc0c7aad31506fca5102f88e64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33811219c920ccc18afda48c985600483b1a322dc98c62602f7cc8cb17c8afb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "439e62c77437b39a122fda61f5032ab34fed91468b652c29cfb231a1e9f08138"
    sha256 cellar: :any_skip_relocation, ventura:       "108f1a93bdb8ec535cee19483f196a7b554b4af0f6390edff5343d29d3041516"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ef5f52f33078aa34af1db8416d697f6f3350006301001f5f2a1a50c316ed06a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c7a342f36687407e00cc62f904f01d2d7b269687a13398999ed28ade6eb12e6"
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