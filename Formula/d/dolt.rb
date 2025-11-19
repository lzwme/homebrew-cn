class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.78.0.tar.gz"
  sha256 "615bd81d21699035ad419d6b2a5a042f09953f644fc82c0f64eae37edc7b0b32"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "92a0c739ee265c742845c4e00aff95955f3d0acac83dee33de307e92f55ceb58"
    sha256 cellar: :any,                 arm64_sequoia: "06eafe8275da3707459ad2da4ddc8adc0593e5ffd7d0952249891a76777e5b51"
    sha256 cellar: :any,                 arm64_sonoma:  "810620f68155b14fb993d23715108f2032859892429d69858514f41fad07b6a4"
    sha256 cellar: :any,                 sonoma:        "033449d1fa78e8e14304ccc03eff0cbd62e91014371ddfc0e5c13667c7866406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9089c2cd7818c81c7748d36f5eefe68ceac2c04ed7c98f20329e789248a99369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50027ac56687d56fa3629951d0e8f98308bbfdb398835df2742b9916268f120"
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