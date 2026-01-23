class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.81.1.tar.gz"
  sha256 "d6558e0fa830e0adb0a74d1e5002793151605ccfded8b1c9e5dc87bc86342903"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a06c873c74dd3834eba080001c5cf45d2accfd8e86bbe63781a27bf88ecebfb3"
    sha256 cellar: :any,                 arm64_sequoia: "f7b35fb35a9c6886213dc1edadd3f49e07b1036df55ae58776fe26077847b38e"
    sha256 cellar: :any,                 arm64_sonoma:  "132a7b39f45a704ccee1e2254df6c6e0d3c2f283a9dba430ca3469c4212228a7"
    sha256 cellar: :any,                 sonoma:        "74ce37970a381355c868050f2e7cc9be73b22924ff53d5b8579e1a557d8a00e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d5ccaabb5fcb7531a0bbbb9b5446521c13b57dd9ee22b139131a6afe8a7431d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1238cfb949b8567fe13d63e3f1a686df568fe63cc249450fb1576da58e65d63"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
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