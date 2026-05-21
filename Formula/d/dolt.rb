class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "4145885ddc4bdf255fa82af824ddf121c9c4bf428103150d371f13e403b59eef"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01450ca98fd23c2f73551e38a1ff4426463ced925569ebc6f574b974b7c8ffc4"
    sha256 cellar: :any,                 arm64_sequoia: "8b00e27f2448c508f77cbb8637eb3edef5401434aa0b6649a9114f4a265784fa"
    sha256 cellar: :any,                 arm64_sonoma:  "a8501026c92873357b1a92b0b1b85e8b3766954e44012b4c2e684cfa6d77cb73"
    sha256 cellar: :any,                 sonoma:        "c291cb42445a3c3affb6450ae0bf9a4a8856bf2173c7e2fc229cc189ffc0d478"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42ffacb47ed5933dd8110fb3ec512b78539971d8733551bf70d6d66550c44648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c549ba9c4a3e4b3212af0db399c9283076818869ee35f0bd1d15c538ec12a469"
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