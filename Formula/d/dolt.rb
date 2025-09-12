class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.59.7.tar.gz"
  sha256 "1060d4574926822ea54de124f8af45b6660ccea7abd88fd889bed41019428054"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afb08a1b537be655be696dc1d81d9955a0db397cba71e0a766e9734e00cc268e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01ff1429a21cc9d4de921896a74c0b7b385c51651afa34b649fd28eec130c9f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb5adccb10f44e7d0b78bd3aa760e131685ab8f5287990c48a613d8179f8dab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "50d2b076f1561d04d27cd26ac7d85992fcbcd661a387f2dcbe6b80a23a2ad50b"
    sha256 cellar: :any_skip_relocation, ventura:       "97baebf34553fe47aa7d6b1c7a3e3f26e5bc62ed8b7c7527f658c069e7da7e45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "938030c2b97a2092f58bf3a82c601166fd379904b428b1f37c5d95767f49ba36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0248ba0713310923e5d72d7f5244de302a1100f612b11847f8de5785bf8c2575"
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