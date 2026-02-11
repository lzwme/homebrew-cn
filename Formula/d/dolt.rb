class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.81.7.tar.gz"
  sha256 "7534c945450b0a8d96d52bc712972c147aede8a0414dca34cc4c75e8e5ca7d52"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b4e3886944ba2c6f0827bab25a5a14d30080ce02c517834f51f8fae28fff57c"
    sha256 cellar: :any,                 arm64_sequoia: "f4edb9d897eba49c92e08db541509dbdedecbadba933336138d6a3c7cead1be9"
    sha256 cellar: :any,                 arm64_sonoma:  "bc223ccef92463fb7ba77415ad19d8c60d71632da385cec8b9b66b22a0bb2771"
    sha256 cellar: :any,                 sonoma:        "dd5c83990bbd064ae6c8c25850ff0e537c653350f2f76ac607f98c73f305082f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1b423abcaa39a20f58c04e1e965aa1d0719a288b819e22653bc867f5008b8a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72e221d660b9f646f724e487676649ee97e9240a65f8afcf4fa35bb9d6ded0ea"
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