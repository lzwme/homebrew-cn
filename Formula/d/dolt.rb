class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.59.19.tar.gz"
  sha256 "5fc6db64b2eb80a592ad2b80fed72843dde1971c35d1d72d2b0ce374859c746c"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "993de26d5168f58d99c1092e116c0c498e5438de9b66a9629f555d40675e60b2"
    sha256 cellar: :any,                 arm64_sequoia: "8823f912dba9f53cea1a6b6bd24b3d5ff1d95be730cef1aa6e1e9620dd8f9688"
    sha256 cellar: :any,                 arm64_sonoma:  "4af95efe663163011db9be9ff4699c18659178af69490adb7bd0358d29839958"
    sha256 cellar: :any,                 sonoma:        "e7a3921b7d75cb8b6ecb6b5e8b453b2387815585e895edc62ac9ead4730d1124"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0de8b65895847560f130e11ff54624407cb2a5829cb72b8331e06543cb61415e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5713c609cd0443d7477174c7e21b3f32ec72c74d0da36a51cf9e96ebc11cc2df"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

  def install
    ENV["CGO_ENABLED"] = "1"

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