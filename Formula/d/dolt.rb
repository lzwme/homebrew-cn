class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.80.1.tar.gz"
  sha256 "1ba057b72ba4c31045b0b415fb7f3dfcbff93841884296775b70d79e326a9a67"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b4adc0d021d9fa3e19c62cf0e124ba7a61af63458a2cf67ac06a026e6c874f4"
    sha256 cellar: :any,                 arm64_sequoia: "91b4ad8404c8a800769b299ed31ccdd6064d6960fc80a10cd925f0ec0499bad4"
    sha256 cellar: :any,                 arm64_sonoma:  "c1a33545a9d4530f56420e398b0adbec47c0559019f27d185b59faddf48d980d"
    sha256 cellar: :any,                 sonoma:        "e5c76df36c1db99531ed1ca8715b1f9fa58d96b6704e7a584ebade09831d9308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5013983afae811e40b5aeeb124d7eeb8f892ec15f93689400b372f8d40792e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2cff8a9b0785e7eb0f980c079b335e90d7973f7eb49d97bbf713baf8d68973"
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