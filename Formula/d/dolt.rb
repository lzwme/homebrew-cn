class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.82.0.tar.gz"
  sha256 "91885aeb9dc5ba96424d2072aaaba53f39efc749c4d31c70df3108446d3243de"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13d637129cc03d95f1336ae8ed7b6e1b76fe33415c825a0133cbfdfa662f27c7"
    sha256 cellar: :any,                 arm64_sequoia: "03255b175442efb52c7bc2d7164d9f51b9e9b569c8759307ab683718a05e54c1"
    sha256 cellar: :any,                 arm64_sonoma:  "e129e6ff6f6484b320f0136e20af0d532cf3b78ea7cc24525ca0c7cdcd0e1cfa"
    sha256 cellar: :any,                 sonoma:        "8e7f1e9a97c751b32743a4a3c0dd4c692f737c5e20eeb84503868ce67e862cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f899ac402bdc3994820931bf91fa1c9e3fd19f5f9e41600617e927ede195edab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8b2bf24b22bbb77ff2e934fc1dda237d542b61c39cd965f0833b4642c7bfa92"
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