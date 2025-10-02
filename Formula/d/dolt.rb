class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.59.14.tar.gz"
  sha256 "7be3cce26e063a43252075b989ef66cc567b373f632cba3bca62e3e832e73cbe"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3fdbe2a8e0b4ff5c9d0a61467b21194c7801a102eda61a4e4dcfa42649b43e66"
    sha256 cellar: :any,                 arm64_sequoia: "d534f1de120b013d794534ee18f03bf3941e5585d987255e4e12784e19cab1a6"
    sha256 cellar: :any,                 arm64_sonoma:  "2f9bf405302264bb5c4e49a2893b152b829f0e731891307448c474a6abe1b3e0"
    sha256 cellar: :any,                 sonoma:        "72681949a8a272f49c6731dd865f2d2ca5e4bb120c02cb9f0075ae56d6c3cf81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3e979c8ac510beeac4a1f89844f383c50d5b13c6b871db752808a42e1697599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dd4c838f59b1539c3679bd44260cbd524a3db70c4d62201bdef3bb3cc421523"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
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