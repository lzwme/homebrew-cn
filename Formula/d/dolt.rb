class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "afa43e3109565b533ee08ab9a71e94a3b38773486730f11e85168dadcc699b40"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c31b0021d6d3735b068995b3a68812fa98a077fc9d3a27df3d236eed82ac58be"
    sha256 cellar: :any, arm64_sequoia: "be87cfd7fcba2073aa4818c8c91e1b3582c9633eb8fb4ec1e1ebb3b73e26193d"
    sha256 cellar: :any, arm64_sonoma:  "e390cb3820a67b82d627e6a869fe93a7114953fef6b078bb45553ac3a70c3024"
    sha256 cellar: :any, arm64_linux:   "818a8767790e1452eca4c19e00062f7ca1fc913be8b4396129ce4677998102de"
    sha256 cellar: :any, x86_64_linux:  "7d00e45a0584c9d6083d5c69e568e53fb4333c19abc7f91df8e65cf513a87e96"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args, "./cmd/dolt"

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