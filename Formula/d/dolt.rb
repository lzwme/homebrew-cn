class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.81.4.tar.gz"
  sha256 "77735e9905301978d6ab6d15859c0c6a56451e5b76aa55d60598399651e994ae"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "740561d409409c314ff0050daf1e79c48c9bf41b5a7a36c8a0d170330d6a56e6"
    sha256 cellar: :any,                 arm64_sequoia: "e7354a2964cf4665d4811a28bc4c7a631f8a63519b7bca8e2d541715dec4d6a8"
    sha256 cellar: :any,                 arm64_sonoma:  "0d1ff24c4b37135a8a3659c497c794ca95b392b4d5f94370a8a7b10f08acbfd5"
    sha256 cellar: :any,                 sonoma:        "3c1855608c095a435a6724bfbc5a52f9046ac1c4e441c18b0c983b067abd5555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3263d1acc78771da982c6a00c1564620055438d1050c0f9be905e84417beb6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a68c31b5b135db438b260c2b86d1a3a5a87cc9b6132bb3025e8db85ff0d86b1"
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