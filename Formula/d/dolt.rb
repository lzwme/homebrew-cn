class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.57.1.tar.gz"
  sha256 "3f614d743e08751bbe14a291eeb3360c00599e760f79a95799b9c155bd655012"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30b56b5871d5730d71b03e62cd95a148dd31b6ed6b54654811872f2b7ad22fc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed6ffa010ea0788fabdd7849cbfd1c5e10c843f0eb5f109f017bbe0b2c5b3acd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2c9c18e88c6bfbf38eedfdb76ea64e2ffcbcd993e2967bb6c3fa6e7ce95d69a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a562dc10a80d0686c8e44951b85918258138d141617905e32f84a2b7ad0179e"
    sha256 cellar: :any_skip_relocation, ventura:       "5183494fd5a94989f6b2ad4b21b8740343d66f3d7edd168bdc9f23ed7e3c39f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9690b2ab1626e17e4e34248e1b53485a31735e9421f70d7aba3fd7391f21f4ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75221a7df98ae9d0e84bbe105f0602ff2faec92246dd862f4703875b46298f89"
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