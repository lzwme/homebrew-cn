class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.59.18.tar.gz"
  sha256 "1b5b43a5b36ed5efbe1d7070d1f58f089843b89da33ee794bd23e4612aac34d9"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2abde4206c036a9125b11ed3c2865b43083985ba421955a0e5bccc9b88f4dd85"
    sha256 cellar: :any,                 arm64_sequoia: "ed4e3076d4d371390cb6d2b5f8cd3575a54252347f96ef8d31f828d16a2ce0c7"
    sha256 cellar: :any,                 arm64_sonoma:  "56e78e81f07b7ca9f3044327eb6b7d51355efea48149b2d9fbf285ef6f7c5390"
    sha256 cellar: :any,                 sonoma:        "851afda61de493cca388969ed3c82ccd15dc2cedcc0be265552bf8c783ea46f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bccd99c74ccbf0d587a2deeaf500cb6eadac770551d97942e9df9340e644b971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd15ae61cdb95166c922154828cf368f1da403ff77d8a45896de0b1a8612a3f2"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

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