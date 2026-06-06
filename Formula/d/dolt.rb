class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "42b391e7c632ede8010a4ab2f570d0b2fa07ec89ebf3f8c4b12e94b0b2bf059a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "351534c30ad417623fc60a5232d3f9b6eafd941eab9d654b2a714e968346f326"
    sha256 cellar: :any, arm64_sequoia: "f679da87170a35e560355018938e5db2c1c6181cd088eff9a45614440eafe768"
    sha256 cellar: :any, arm64_sonoma:  "c58a110008fe84452a97b6aa681b1bde60dd3f588e2933c72a6cc00b90f8d27a"
    sha256 cellar: :any, sonoma:        "16c6c9e644f80b3a74428d8253c243559501513e0be4db3fcf42c604cde28844"
    sha256 cellar: :any, arm64_linux:   "1c301d6af0973f619090bd88757c7cedafb1cca06e88a1543dedfd69b90b540b"
    sha256 cellar: :any, x86_64_linux:  "ff357ab553ac4664cfa9b96d7058ce535def15f4f54218351ec015a991bf26a1"
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