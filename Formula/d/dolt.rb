class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.79.3.tar.gz"
  sha256 "8c1de5a59ce98df4ef41c5f1c6d93ec1485b42e44c38186795e6bc1ab215d5d3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c65c29136c16fec1185edc8d7dd81cc8d8eb11731cbb3c3a8aede0d48563d712"
    sha256 cellar: :any,                 arm64_sequoia: "23f12110cf35412d820d149b11b5479cd592b1de21a63891815187edb20c20e2"
    sha256 cellar: :any,                 arm64_sonoma:  "4374184861bec097d908182a8ef00fdead1543b9d25a990b9b985089e704a131"
    sha256 cellar: :any,                 sonoma:        "0ee63791e1f4a0bd5fc7dc2555e088ef370c4270b0ead5d8fa9f11bb0be7049e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97e20989b72c9442790edca5e319bc67c14460713e75ddd7b153aba9d1fc41f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d802d07861425a9c60cb3140721e5ae87339265d6ebd92f0c0e6d06a18c72eeb"
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