class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.58.5.tar.gz"
  sha256 "d69049a05b494d32caadf9021b25f9855a2e21e641e2be27ac4fc52fb7625ba0"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41903b8d4f17bb63db97fbee504601aefeead6d0009b25d146129824adc760fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e91132c137af91cd59ad82484eea47147ed50f33bf51315cdae6d7c793c1a57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0840e95b6571715f23821aacc47cd20ce2fbddc9a00ec619d7483d8b25b5c15"
    sha256 cellar: :any_skip_relocation, sonoma:        "289bd8bcfbaeeb89e8365998bd1eb56f852959fae8fdb6c40ef88979165e80c4"
    sha256 cellar: :any_skip_relocation, ventura:       "709d8a1102d379bd9ec548f284fb57398b3416e6445350b08636088f745da634"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6914228d715033161c997b2b3f9587398acbcb9d89b6f4a06d100724c9918564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed39117a0410f3241b70237cc14ae21c40fe5fa0b97f61b4ec819bdd22b6a059"
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