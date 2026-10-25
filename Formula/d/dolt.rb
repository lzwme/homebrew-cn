class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "ad4eba0b1b39d0696f3866ab20385efaa18e3701e67123aa3d1d0f7e2ac7700c"
  license "Apache-2.0"
  revision 1
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8845e4cfc7115967bd29c35a95715f04bb9c7d67c90e5b8b057a2d6a4460af38"
    sha256 cellar: :any, arm64_tahoe:       "f12dcd93d3b1a5dc55cba238774ddb055ce2f855ed46b8ab5d4c65cb159b7154"
    sha256 cellar: :any, arm64_sequoia:     "8b51ff9cf6d216e4d93897b0c5b6ab7a06e75e4f368f526b9b50530e45f439a6"
    sha256 cellar: :any, arm64_linux:       "b7de5565ae528de8e0b021254d336224d4879fe6e253f817a65e5a969a8166ff"
    sha256 cellar: :any, x86_64_linux:      "acfa62362f7bb967c45b3f3aabeffd8efbea34faebb0aaad59674535140242bc"
  end

  depends_on "go" => :build
  depends_on "icu4c@79"

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