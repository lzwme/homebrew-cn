class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.80.0.tar.gz"
  sha256 "9a16138580cc79908736e399cf0a07539783026c9919c381e23644b39a0c6ec3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "095d70db5a1336cdd9bc9d0eadd6a7ece331868b339948afadc79d575a8f7319"
    sha256 cellar: :any,                 arm64_sequoia: "d241a6a96c3c4c1d7b36d1228b8046e8a23f2b0b9b402e138072a01cdb31bf07"
    sha256 cellar: :any,                 arm64_sonoma:  "c27b99a157192094ed2d00772ae83b18feb55f4f1b1532dd2f2ec367f9d33c01"
    sha256 cellar: :any,                 sonoma:        "997f98be3475b75148891a7d296e439ecb3c76175a73bd56f17e07627ffbc866"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cbbe182f87f8348ba34f74b51eb85034157a3976a7195251b7ddf0401444c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fc8d3c01ad0a6d59503fa5a5ab233f3d9c2949be5f886a098d55a03a4a036ee"
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