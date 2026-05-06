class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.87.0.tar.gz"
  sha256 "1202b7f0b3b1b2c75e9a78259b2c95df73b76a356ecf9cffc8be4af58bddb9d1"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65dd6347268980acd73ed7576fda275121b5191035de78a860c43301ab98263c"
    sha256 cellar: :any,                 arm64_sequoia: "3998437abeaecc8fdcdba5eca83d4fbbae781d97f07dec1ae9b2db2385008ecc"
    sha256 cellar: :any,                 arm64_sonoma:  "69b5a740257c524d82129cb2536ef92212ca58fb332836b429f51cb6ac218f28"
    sha256 cellar: :any,                 sonoma:        "d7fe0f168cd28269603946b67bb378749f8502f157a1d4499b0b9fb3e364f261"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0390e1bed8cf83d19ddd1505e2a8f9a6b595b4ad6a955dd8ad3b04befe15c8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c56588c941844cf31972b224d445f5143bdc0441c9197800da30efa3fc8903ca"
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