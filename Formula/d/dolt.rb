class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "d01a7fc55043e7ec08fb6e5ada117c39c58db3974020270b91498a1a5b7d61cc"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8b423a6f7638ea05974561c2bd97a78576d2833a78ec447b9ac8b2653c5ad65"
    sha256 cellar: :any,                 arm64_sequoia: "f4fc0ef8083135d907542df33c1b646a0e46c54a97278118c076f416668e7cf6"
    sha256 cellar: :any,                 arm64_sonoma:  "0f39cf0a3c31e4872cfded7cb88410ccbb7180c101970ec74e76550a0e347f2d"
    sha256 cellar: :any,                 sonoma:        "76a7e7367c94f7c8cb271ea5954bbd12de49340160d034b7928fd42089db74f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d4a5e8c197cc05daa21ee7e52a10d4a8f37be30a905b1b83b72affac1b003e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9a366088a22200e131e5786e3822fb37dc9d65e19b0e07964691926782fa46e"
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