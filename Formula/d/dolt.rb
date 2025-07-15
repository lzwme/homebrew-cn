class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.55.6.tar.gz"
  sha256 "370882655f5e6624be25d62ed668b444df4785c52016201e5ce672babec847e8"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "764a8effc01b05ce4924234b94f5f3da0e3f4617cc9d11fdbe8bf4811bafac5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a87d0a4ab2274af6e071a634236761c2ee0a13605f4f2f4462425d11a5242e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82486846d018bcd4349aa8f7db6e8e52f6403949493edab3245dc368a7c0d4b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "79513aab6e937c858cba229283dd5154bcf5ba4362baf13f8d2584357429d8d4"
    sha256 cellar: :any_skip_relocation, ventura:       "86efaaed68bebed62a76081f74d78f44171dcc2840c1f0df3900d6a6eba9b9ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8852f36c8402759cc65367d232517b0117dba221794fe9840b364d259635cb23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ba1c5dc825fc055acd2620062722392e8d6ebb5e9d9b54990bcc14a3dc3d987"
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