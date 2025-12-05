class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.78.6.tar.gz"
  sha256 "590cb2ea27929a7b7ce4bea16a7bac84f906562c10550052531dd0251cc45347"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1feeb5157cf630dc6e192591410c54d3db7faa86690990b84d43b62f44e6be0"
    sha256 cellar: :any,                 arm64_sequoia: "7b59b1bc34e3e7e7a61d0244d4e9aa5e207c1da3d9a4270385119faaaf3a11d6"
    sha256 cellar: :any,                 arm64_sonoma:  "68e5b12a7e9069853a162a0954d300feb28f57e9660fb78831181fa9f92f55c6"
    sha256 cellar: :any,                 sonoma:        "c43e63bab9d798bbe72277a47f4f919575b5ecb892d404d33f88fc5343975a17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74aa133c3f55903ff6ae953d7a34af63eb6dd6e200589b100f6aba4c5d677f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b8f9e5b438d7ce4517f837b2c9dd0793ffc4bb0d8e506ae81f4462a3f86d38"
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