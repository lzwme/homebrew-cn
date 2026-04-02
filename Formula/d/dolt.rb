class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.85.0.tar.gz"
  sha256 "e5535ddf3b044ff0b34b7676fc30ad5561211758e2359aeaf63d1dfd4dfae17b"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "679820ff0fd076d0992198fdc7a7764db7429c03d1eb93091be3efd4864db753"
    sha256 cellar: :any,                 arm64_sequoia: "b1cfe5580bab7f190c825ef769b91bc3053e8ecb15282b1c2a7e7d3a0a52f1b0"
    sha256 cellar: :any,                 arm64_sonoma:  "73e430921084681826a7452f21052566c718457bc7f6dfd60f3fa8ecdfc174e5"
    sha256 cellar: :any,                 sonoma:        "9b93b420fe77cb9d25767b55ef87e58576d32af56a0f937bd2ee9a30c03168cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfee3c3673f422fd69b92e95c2da1e75ff6c1f8fe2a0e885707205461dbf7453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce691ba3d492e6eee6844622ddc215245c5ee32849eb4ca154dc57f0ad07e22a"
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