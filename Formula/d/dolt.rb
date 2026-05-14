class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "2edb353f3c4f25ff782cd627e08370387415c2bbc7157e93b84891e7ff1c77ed"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "172913b038d57f8364eb5c63ec377dbc919d6cb4fef7f03178a1f79a8d05e829"
    sha256 cellar: :any,                 arm64_sequoia: "dcca74e331d2b1a4be3927e08c993e4cc68fc2489f050a0865f874c27b82fe2a"
    sha256 cellar: :any,                 arm64_sonoma:  "a3371917c0fdc44d3442d050aa23843c70b9bd7899ae36b08eb4b63dd44948dd"
    sha256 cellar: :any,                 sonoma:        "664da27e77058374d9f4233483f336aca1652785cd3c9cecfc0f13675d8ba3d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e475393da59b8f979787e38082bd052e1936ffae4f727e18928ba5e57decbdb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71be1e7836851098266e36c0a1a5856b4874d4027f9083cdfdc2cbe4925d2a97"
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