class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.53.1.tar.gz"
  sha256 "7f1ef19a183aaf33bd09f5014d38d7b66803019ac60cec4597b3728d7c3bc160"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89865cd9d040533bb6cef6078023c84cea20737a82aeb4d61288dd4333edd91e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24de1f2f61172a493948d78bde1b52ebb1a7961e6199fe9ae117197d25898170"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbf02bb849f067edb1877ec7859f10347fd82b5f2f0329d21dfbb8d4629c8fa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "78d367bab0729b4a2283bffe251e2816c472b7c098968b7bf6f51c79099f9187"
    sha256 cellar: :any_skip_relocation, ventura:       "8de1c04430e4095f69f92cc96f64627686e19797e183b311d40245f3f73351a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c813ff3849f6a5f50d1534b1aeaf094101fd7a8a16b19881df1ce68e7bb04c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83699b0807942a3c7353a66e738e6e52de59673fc89dd41aed08fc5b0358b3b"
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