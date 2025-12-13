class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.79.0.tar.gz"
  sha256 "452a826d90a426529a82fd5561506138900bb570903b8eeda6f6c9c2b007423f"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a3ed289c76529ec8af17407a9b531dbd4afaa0ab63968064046496b755d85358"
    sha256 cellar: :any,                 arm64_sequoia: "236d703c6a8508d43c72c5d31c21c58642321a369a20a8926193dc518f79a8cb"
    sha256 cellar: :any,                 arm64_sonoma:  "2e3e871251de78ce762cb67d61cdbcd000a7166ec1102583ca457cc92c929857"
    sha256 cellar: :any,                 sonoma:        "03c38eb30ba887d3670b93a41a9e2ff320bc8ed394c3444edb4dd126c0db9f2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "210bab6cfb422dd59bb6451c233b530316d5c25976e43e10655f140a59c77ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d569637027aafbe7f2ce39fb9de249d2412a3f73394e6996a060e846e1acaa8"
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