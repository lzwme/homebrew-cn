class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.83.4.tar.gz"
  sha256 "7a9386c61d8c7e5cf135911786c1c0bd407c7ab63655cb71dd4208a7afb79e0b"
  license "Apache-2.0"
  revision 1
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59ff683c2040a5cd1d8791b9b402f8660a5e4be286a3033e7fa85f911cb1df2c"
    sha256 cellar: :any,                 arm64_sequoia: "bd59f0cd3186934c49bac17df188fd5263ba4da0d509cff18b0528c20d14cacb"
    sha256 cellar: :any,                 arm64_sonoma:  "cc2b419f9d35f51e5597d38070747b5b66c9009d3793fca6a77dd16ffa7779ce"
    sha256 cellar: :any,                 sonoma:        "e3f1b7f7799ef31f1958cbeef34ecde42c19b3f01560941629de396eb80c6da2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d9a013c212b211d0671d77b65e3c3cde10b1e48146c52fdaec2ad606fbc4a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53bca912df3ea5ff3ad7ef3b74c76eac6dbf5b3bada8e2b287adc352e54e336a"
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