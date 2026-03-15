class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.83.6.tar.gz"
  sha256 "fd05c4f98f43e57dc76117a7a654f3a174d5e62db7a316f2f1848f67f2e93b2d"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f9c1606118bc8a7420a3f08709aa7445a9b930b9d23c260a3f8a9cac6840f4f0"
    sha256 cellar: :any,                 arm64_sequoia: "91bdd7caff3b7287c9b24d89724fdabe5ca19f4a7bf45b4ce0ea82d93ee8552e"
    sha256 cellar: :any,                 arm64_sonoma:  "2ab7b338fc7211d8027af46492db243d3dbff6b7abc0ac5d0a3781e78001dd1d"
    sha256 cellar: :any,                 sonoma:        "4e32785277e3b15b3ead74037d7a1ec29e23dc1ca5e5fad5c86a9586127f9e69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52263106712b7f1533e51afc736aaf32649df207604923c9740f596cf5d323a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40d78b2cbf632cf2e6871df1db846f853f20e369d005108e9465bcb3e7168b46"
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