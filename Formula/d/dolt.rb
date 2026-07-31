class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "35e03e371ad06f860fa2289970aef50a71ea928b31b0fde51920cb4017c06aa2"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1417c48c86e2eafa154edf75980ee2d496cd43913d10581e9a6121c12c9abc5b"
    sha256 cellar: :any, arm64_sequoia: "72f01a8e484ceffc599f7230d704fc67e87610d874a92ac844eeb3d642828c0f"
    sha256 cellar: :any, arm64_sonoma:  "b8825cc2c4deaf4edeff050ce38fbf5c0834938e7c7df56767d4b15dfeef06c0"
    sha256 cellar: :any, sonoma:        "bb55ef515c6fa7e184a9d4a0054b402548ad5b81a183a3bf22424a228b977cbb"
    sha256 cellar: :any, arm64_linux:   "7235ffd32b1fc1cb550d9f0394bafd7b5d82fbf8054a9ad9d4d0287c3a62015c"
    sha256 cellar: :any, x86_64_linux:  "a9f26dac49a96d952b2f008dd739f9b4208ef5869a760e6e398c7269e165a24b"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args, "./cmd/dolt"

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