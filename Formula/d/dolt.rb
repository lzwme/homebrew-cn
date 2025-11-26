class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.78.3.tar.gz"
  sha256 "be9a400e07b1e4b1f0f25ba4af89f25c60a1af8c52e4844e48f6dc301b1a9a53"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34c3a5f2e6c4d98498884b0d837bb74b6fb958a545dc5199adc13d5e8656fabf"
    sha256 cellar: :any,                 arm64_sequoia: "11cb3c3deee0cdff7c414e5e47f2af19d89097ed99e79002303e3ada0b515c89"
    sha256 cellar: :any,                 arm64_sonoma:  "e01d24f5f868f4cd57d923d90722af6aae3b145784498d72c3be593390bec2be"
    sha256 cellar: :any,                 sonoma:        "f83d4c1ef0c421b8fb9192eb6e13246dac59f65d4df8b6404e19a783d2d0a947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c0041174853e99eefb7a9f6caeb5782daa430d44258a7210522a9db1ba54e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a4824729409a59087cff071bcfb0a583c88b9eede9a8cabbbdf7c96545306db"
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