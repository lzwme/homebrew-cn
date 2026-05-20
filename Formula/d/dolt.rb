class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "26b896d95bcc075067913f13f42a46b6deff7ce1548a2b78bb23ced324cd50af"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65eeef4c7e3719f89fef432eb53b4532362094d1d105724e1dedbacecfb07f50"
    sha256 cellar: :any,                 arm64_sequoia: "a09651efd3aa63f0cdda83d8132729142883ffb0703fb500484066f017970e59"
    sha256 cellar: :any,                 arm64_sonoma:  "ee9cfae9173a47e3e64729a55ece5b226574a9e602ca6c149a1eef24bdc73e48"
    sha256 cellar: :any,                 sonoma:        "3da55ce466a6e6d5c25b46f0bc4910ee9b92abac0c3fb4724337e260d735b17f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51d0a80fb59bd6588e35449cb3d5bd9689b8a7fef72b6bd441b487a73773be3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45151a8ee3efb5af312eadc235d9bc409b60ac81a660f590b9aa5fb7160acc3e"
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