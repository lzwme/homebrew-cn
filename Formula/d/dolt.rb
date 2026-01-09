class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.79.4.tar.gz"
  sha256 "0aa963c52f874dbbe6ee70f71f9effe04ebcbd6ac7d04c4ef7c0ba2b3ac5a02c"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "308c834d97e5b23765b91c8fd41ae3ca1689930b5c867e871c76e7dac37d8455"
    sha256 cellar: :any,                 arm64_sequoia: "77ef738ba9ea9d352a66466a0ccb1c0d4683597fdd9ec0540e7005a3ab15792a"
    sha256 cellar: :any,                 arm64_sonoma:  "cb8e0248d864b7277acbf1a3b04a68d91fa92e31e197705e629d95ac662c3468"
    sha256 cellar: :any,                 sonoma:        "c0b5191e02f96f12fa1d120f9e90497102594b6227d751a9aa62d2af80641224"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0f2719bfd4c2a5d65bed319c9c325bbdfd69219fa7248f87424d853ed61ef2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "346802672a64a318216f736f16ee8315a87b02da808694c96c9dd9ebdf862ae7"
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