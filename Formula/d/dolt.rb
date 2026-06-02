class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "2c041caaec70c075bc55bacb168cf508f440fc6fae9b3876a551400328bf1bde"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ab3d4ffda5f40308c66449beb9b83c59435da0cbd248f0fb611f7f9cf2e97a2e"
    sha256 cellar: :any, arm64_sequoia: "57a481472741d95eaa61be4973cc0b707b729c89e5df5326f9126d3d61e5230f"
    sha256 cellar: :any, arm64_sonoma:  "5a0f943b3ba21bd8b3a0fc60a32435c48f0a956cc0b89ff3cd4a3e392e3c91b4"
    sha256 cellar: :any, sonoma:        "3a0a526ff5397ef30588c8f3af8ebcd1808748f570c2a0efe572f087bf59a5af"
    sha256 cellar: :any, arm64_linux:   "85b78de12ee0144c5b07bc99e872159bb2d9a1c512788cdb953493d5f45ae2dc"
    sha256 cellar: :any, x86_64_linux:  "8548f07a2aa50b5bc39e9ec5d2ab9ed8840bd1664ab5c5692f23152825ea27a4"
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