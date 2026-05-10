class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "8ab6fffac090628f6d36f10f30e344659c126b8aa5353244f65b82bbff5b0082"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc15d415fa904220b38d2a5d95914db6841840cafe3836fc6661f2295f3086cf"
    sha256 cellar: :any,                 arm64_sequoia: "09aa744381486da49c49465ba1430e0e491e031777750a585d736eee75786604"
    sha256 cellar: :any,                 arm64_sonoma:  "1905f55d277242def3acec519fda809a10adde907a13e217e252190835bd0ffa"
    sha256 cellar: :any,                 sonoma:        "d1de5b58cdaa8bfb2631b895b4ce99fb1345c82917327da5c08b331aa2d3b016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52284c338e537d1913b61dc5655f21eecaf943f451e9c1ea0a79de0eeba7eee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "103d9724210833bd8892f82961fc436b564c8d461a3aa3329c3d0abd648273ed"
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