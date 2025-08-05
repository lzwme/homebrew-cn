class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.57.6.tar.gz"
  sha256 "8b598f5c44001b8a3605620291238a7fa6cb974be11f57f8b209e5dc19841fde"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7f367bfdef4e648da4a6bc9b8b8d08b3df81294be1a109c11bb2a7ebfbea188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a4e84710acd2f2bc2150c9c64e0e2a2c610dbeded8f635b1a0116ff6de2178d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1bae3712187073d6c92ee0e024f93ec0cdd9d53ca474afd07e2d18be99fdff1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b8988c466499bb94baa7102ae70402dbb4c4724741b3c443d27764cc79b2966"
    sha256 cellar: :any_skip_relocation, ventura:       "fd983cebd9070618ba20eb8b236df65483f567cf24830ea776ebbaad81d0a9b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afa6d050244d16a6a3a33f14de7bcda2cbac387e7a1771e466635c19f5aa2ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62be07e4d61629d2e7aaa825063b5edaf4957d38c6381652a0c1d75cdb692657"
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