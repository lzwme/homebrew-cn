class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "1ea1bcd1230298de3790b4ee1072ee287ef1a9ccafa74bdaa001e3aa6c9c8fef"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed9c1e8266406981af3a2dfe41a249c5624e98533e03982f146b95473cdb1049"
    sha256 cellar: :any,                 arm64_sequoia: "82e3fa8e7247a9d9fd38e20e69074dd74b769b6ee8c8d8414de80d994be47569"
    sha256 cellar: :any,                 arm64_sonoma:  "9f2ebab8f3c3e2c01ddd6a3ecf2c44d47e21b2843f7325b2e0a0d77a1277100c"
    sha256 cellar: :any,                 sonoma:        "dce3d3125224651770c2d704f28ecc48b7bd2b0b48d57e015e71a10dc9fe5c73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db4a15984d0c37e27db426c7cab777eb0b11c143ad482d6ac2474f83f4bbed11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "078af7357ff9629356197857def8103f216a8b83fe013faf7fffd0b5f17c3148"
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