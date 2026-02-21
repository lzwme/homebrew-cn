class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.82.3.tar.gz"
  sha256 "96781c7ff214559819a93627908e6e0091492840033c3cb6936a186158e782de"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b92a21c44e0fd91af2d4d509c4b71112c3af66b669ea6418a5113cd68ee56949"
    sha256 cellar: :any,                 arm64_sequoia: "dbbe7c43d318c8bee380f4ac8f9b3b2fd7aded127c2f46c3c88618c91f5883ae"
    sha256 cellar: :any,                 arm64_sonoma:  "f1417efc84b1c948e3e8b41f941cf2093723d1d88f5d79167a2c54b94c3a8e62"
    sha256 cellar: :any,                 sonoma:        "0753cdaba681d99e3cd733bfd527ae3281189d3edb607d01c2f8cb8182541c0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc95575ebe59f471bccbb13764884758df44b90f53d07559759d995d64c9c075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d1cf11b71e8f6ff5c97850d814010146662c52615dabb14e02dde7f6f2038bb"
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