class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.84.1.tar.gz"
  sha256 "13c82074d491a391871829c308ab70320253b745d564038996792795244f1649"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8edfa4130731770d7206a16b5149a53ddb04551643509627a1c4cbd1a214deef"
    sha256 cellar: :any,                 arm64_sequoia: "a07b1d9814c907f7ec0050d4dfe5ba1f9f62ba845d3f887154780e5f6b116e65"
    sha256 cellar: :any,                 arm64_sonoma:  "ad7458d384f556832297b6c03bf49914654bc8020a8ec2e6c8140a5f92855c9c"
    sha256 cellar: :any,                 sonoma:        "0350bb9910134dc1b602b3839fa96f06680ec14b05fd65bd2db38ac9cfb7fe12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c3f8d9ab6f9b40af062c5863fef66ed6086a8d56979a9f4d88ed14eafa3ff7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5683a996e5cbd141c1f34dbee052fb419fef3119876f28f1aaf3638699889b28"
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