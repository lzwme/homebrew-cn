class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "2a7c5f2ea5c59b660bc55c0951d325fbf54bd3c638c814b484ef890c3e6bc259"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1d67df53f50291c65fe5d4b83fe8064658836f231b6fd4e26dceee78c6345f6c"
    sha256 cellar: :any, arm64_tahoe:       "eb20cd5dc1cad5cebac691d0507c2a441ffbe6bf3264ac1df06f0c5d54cd169e"
    sha256 cellar: :any, arm64_sequoia:     "a8592bb185f7c42ca0c27f912167f53e40ad603622c0675f3a9af690e9def2f2"
    sha256 cellar: :any, arm64_linux:       "f4986dfa92cd093a5ea9b9d76cfd0c3c65842f2c98e01b2a9167bce96342219c"
    sha256 cellar: :any, x86_64_linux:      "178295cb982628e3e48dce5e343255de4e97fa44a545310c203978fb55cf4d14"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "go"
  end

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