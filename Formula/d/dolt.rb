class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.78.7.tar.gz"
  sha256 "c0a0b63f7219263e1e5eee62a1ce1caa19e19e34a993d2fd549d492693b71372"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7982fcd93336b83ace8646ea0846d227e7fd3d374cb9bce6713b43c36ba1b3d3"
    sha256 cellar: :any,                 arm64_sequoia: "c4c2e06ac61b209864514cec1878d9dd43dedfbad19f8c8746022d4eb44e9804"
    sha256 cellar: :any,                 arm64_sonoma:  "3169f00a829be82e37e28ea289490cc099730bb763b7bccae80a2d58670e90d9"
    sha256 cellar: :any,                 sonoma:        "a7b927c6c8c97fee483c3d6b8695a769d9ffeec573fe168a2df746082aab2d5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b43116426336e720cfd96eb7f9ce39aa8592e9b7ecbd543ca47b23f820d48efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f036f5bd4cd4a34bfa4871a63f530147bbbea75b439cdabdbabe669799f46dd1"
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