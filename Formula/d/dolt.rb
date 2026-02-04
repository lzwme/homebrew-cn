class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.81.5.tar.gz"
  sha256 "af95c9f2fa2f4c71ab7b0286170eeb01add0e4ff2dea0e82b4324a669fb23a05"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4bb0fe8a20994fcb4c4957a00f65bd72235b3e75b584454b9e4f44096471d2eb"
    sha256 cellar: :any,                 arm64_sequoia: "5712e4696cf63ee696ec6a46bafadecaa7c440068c1e9e9deb7555d49073a205"
    sha256 cellar: :any,                 arm64_sonoma:  "66fb80f4652b5550a19edb9793d9b1ee63e3559cba906f9304a14b228367a5ff"
    sha256 cellar: :any,                 sonoma:        "fbee8dee27d51ddd634bc7276ac197b70db8f6fa9d3ce41286592644694671ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84e4561d748977ab71bef8001e97259dd752fe02977767f258333bb3ba7294fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adeedb6f654ef4b0f603b81c018701f0e0ea57face792522cc9de89d393a834b"
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