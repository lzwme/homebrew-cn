class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.83.4.tar.gz"
  sha256 "7a9386c61d8c7e5cf135911786c1c0bd407c7ab63655cb71dd4208a7afb79e0b"
  license "Apache-2.0"
  revision 1
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a6467f69f1862c150303a9e395edb31da59b2148198f7ec3f44fb1da6c5f0bdb"
    sha256 cellar: :any,                 arm64_sequoia: "8a22d6009c6d7719871f3b5d697fbe89d0b9306a3fe062f63f424690312b337a"
    sha256 cellar: :any,                 arm64_sonoma:  "b2676b705f940013a2187927285e6296b3d8dd78695d515ff56e57d2f44fda92"
    sha256 cellar: :any,                 sonoma:        "95d27a498452bd4af35c63adcc5172b101fafc2a42a4cd76421e19cd9dabf452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df99d69ac1bbf93841b755eb9bab44a63117023d379f4851ef8a23dd559a6d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d12aebcafba4e8d07bec819e44b3d3683ed3b01fc73a82bb32451073e28231b3"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
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