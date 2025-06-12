class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.55.0.tar.gz"
  sha256 "b10e6c92ff15914c8546c1bdc210efcb278ba16c804dec82bae755a0b0912e9d"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4bc602663919965fe668bf4079f56c79201295f3d8e55d36a9046152588069d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "114c8a8c086af7381131ddc1fe72d5e339b82fa782cf992dd89b08130b3db279"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddbfc912f2702717a34bfece1ce5c2b0cbe6d513e96d4b3cd9e1355e8510a57c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9541928fedf1b25f1bf0ad3ef088aaa77e425162a753804302b52c92596ca598"
    sha256 cellar: :any_skip_relocation, ventura:       "b6c6ecff1a80c2d4dd6dc4de5d26dfc6a8254db932be32dfbdf7556e43f8d755"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94f8f1cc399c239f075bbc29836b605c0dc3211fe4d8747cedb0d9ef69717bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4cc1398453af3129d462dade25fed3dc13b7a5b7a60a2d89bedf1219a75e239"
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