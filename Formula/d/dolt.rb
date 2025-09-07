class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.59.4.tar.gz"
  sha256 "68ff4ce1511b4472c38c503ddc4addc307bb366c2d6e6e1d668d2b9632f9b49d"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1d337e82cda3ca53565532ba01bae6ca3cf96082be1a29c24a602d509219ee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cbcaee7c58f22315e74173e6192dc3b439ca6cd491d493c809c2a6c7fc4e87a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f322281503e138e4b0dd527d9268793a0b05e8153132665afcaa0a984fe611aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "2055bc6ff77ea36266e0956067bb37d7e6be2b350d82a80bf9196d93359929be"
    sha256 cellar: :any_skip_relocation, ventura:       "f0bfc05d9cbe66a605df7eec8c716e03550ef7c8916e3ba0e9df029b0176522e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40113ce8872197621e78f17443335bb5fd7e0c912dcfad603f5899fbdef7c5c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "745ba91fcb0eaa9ec413e6f822d558924130cfb30702a8f30d07d3aa2b51f741"
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