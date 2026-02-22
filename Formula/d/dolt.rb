class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.82.4.tar.gz"
  sha256 "f01b49d5e1dc649e3c6cbd8ce338d690422ea6e330d0fb474f3bb0196c3a080d"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fed13bc632855bc561033dbd1d960e767f7ea31ec6a2d990f4445ef909ef9f39"
    sha256 cellar: :any,                 arm64_sequoia: "1c20fea0f37aa2de137a751003f41907f80b7152265cc0c4942c42ece9a53a8b"
    sha256 cellar: :any,                 arm64_sonoma:  "05433a7121f8ba8abd5b92bbe3e453fb812253faef1a2129b54fd23d8623e8d8"
    sha256 cellar: :any,                 sonoma:        "5b1241a881e3050340044db6c48ef6ab7ba783fe24b64cf8e394b7c82ee2a8fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3112b75f70e5a21c7a24082733732d4efe9ae6b7dabc3144297281204e69902b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0006278c977b4aeb6a2bcd4b60f192aaaf3585282b80f94f6945bf6ed37f46e6"
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