class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.81.6.tar.gz"
  sha256 "b8bf93d20a5c302661f64a01800ce024ee8d126a5df756e633e7115917ad5c7c"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2a850a16bf6f4c1e534572d38ece19b9a7476398aea3e2fa33fdc71463c9029"
    sha256 cellar: :any,                 arm64_sequoia: "1b3833f46bcfb19e88d6f9c8d9d796823f3838e66e166d305be51a959082b7e2"
    sha256 cellar: :any,                 arm64_sonoma:  "7e8bccaf5c7929c7fff0df272db6bc05b746bb96db5e9281ab9f2d6cdd3e7d74"
    sha256 cellar: :any,                 sonoma:        "6f2963126a2f9aaf8b6dd2b98fa8f901d9d4f8592328ff7f71d40cee10f341b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82adca838663908f8d705107dd4806623296713418ee3aa32e0475a0d202ac93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da8580acbf2f3829d07a8c87599f4994fa85949a2e984fc33f6789352b9adfae"
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