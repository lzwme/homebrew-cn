class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.59.1.tar.gz"
  sha256 "43097cf1e748be72f4a8afc313483116f1e9f65f59083a24731c67a67aa91200"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ffc6d6ba045fc5a363871133078da9787e1ea4fa2a54d1df54ffa6bc7e428f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad454bfad3c86fe9cb84f309b3d8f71cfccabb952be4ed45055a97e8b68246ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e416c74f489a1dff3c8b109e8e1b481cd992d727be59351fab6f52659df4967"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ba6071d97522bec0ccfce4c07f91d5e8ab80549b486c887e125a152112ebd5b"
    sha256 cellar: :any_skip_relocation, ventura:       "787b888d08ae0c616c11493c0edea3cefb8b8620c64907b21401e92ced47c201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6554d28dce01cb3b7fcbd1aaa34538efc309234252d96e027bb518895605457a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "572576b52aa81c8f3b62f50e298d14093e5937239044125a72c026add94eefb7"
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