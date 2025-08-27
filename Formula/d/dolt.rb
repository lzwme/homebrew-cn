class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.58.6.tar.gz"
  sha256 "7f0be68fd405ce27cf336a205619fe6b46672d459eec17e543db3fc571bf81eb"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc6a1e9ceae9cb04c3fba499b10a05a83795e29367a75858425b169e0aa59c40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aa69973e954230de6c4b6f306a032720caaad1b6cb1de87f9c2592fecb68b9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47c17ea3063526220a440111bf82f2d231942e9fa1b599399fee5eae8e4c8a36"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b06a051fa972c78e2d15dcc0125e9d9b6359f7e795f4c01e535e9b6b9e01b2a"
    sha256 cellar: :any_skip_relocation, ventura:       "75c9075fd95df3877ffe60416bb9dfebd39fb985adfdb272384f6a4d9d83237c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49c76db293ca1d2c655de602f2661d57c5b76a6c7acee19fef8260518d68ae5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04d1f9d484cafe1e23ff70b598b4a5956a39f7fc457107089dbcb0699c02f921"
  end

  depends_on "go" => :build

  def install
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