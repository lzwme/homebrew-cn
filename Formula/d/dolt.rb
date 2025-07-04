class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.55.4.tar.gz"
  sha256 "13d8ef5f65e17247957a4acb9195d1b84491a7b845e3480721147f7536783174"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baad6bcd37536e085b3095a143eb68706136dead93f1ef8802e105a230e35250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1451393d31d14fab722665cad6eff7c30cfb335b06c3e785efadff6d2f9e0cff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f69d640b7d942dfa11ed7e30a6a337ba1d70c2569864f31ef9f620bd6492f7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e09c97204718fefc201baf5302ef0324b694d2b235b4d22ee79bbcb08e27014"
    sha256 cellar: :any_skip_relocation, ventura:       "72137b32fd27bc8992deca5e8c507f7fe156d89e08c2dfe2bd8e27a6142db654"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "290237e9ed79243ff5f0a958e409892eef1fef960a06b100fa9ac7b0ceff7a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "720693723c65ce0698ecb6983752dceb77ae7d00983fe9b397caa39d1399fb07"
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