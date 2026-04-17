class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.86.2.tar.gz"
  sha256 "63c0ce0593892513259a8b387108845f13cb9c62e58886c2d62e6a4aff86e125"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "29c8983b0d2b29040a34c7de4c4b58de3225bc97da8f3470bbd89c764cc9f22d"
    sha256 cellar: :any,                 arm64_sequoia: "16a505beb51e2bab8e5f412be9b9a38a7bb3c229706b1719d6e442d7d16e8117"
    sha256 cellar: :any,                 arm64_sonoma:  "aeb452c73ac0ef3504225e11d7693981705c4f56ef800e9972ad6b1dc420ce3e"
    sha256 cellar: :any,                 sonoma:        "e3642e598925c3417655fe4144f2798d3b12767bf0a8785238a6407fe40e26e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e7a55c76088f0bd2c9ff0787aea8ce913c71d1c5e69aa1c79a21d1b6ae84b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c340c218c79580f1835f4c4a5dca4d4e0477b05d00712ad086f61e07d44ace2"
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