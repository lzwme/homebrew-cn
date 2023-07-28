class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.8.5.tar.gz"
  sha256 "bf89904d950567739314ed6afbe82a6d10121c6a014cf6f7e39b210e9963a745"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "653aab096c0de5768b16d8536a99e3f8032e2357571c37d945328dd2335f41f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "653aab096c0de5768b16d8536a99e3f8032e2357571c37d945328dd2335f41f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "653aab096c0de5768b16d8536a99e3f8032e2357571c37d945328dd2335f41f0"
    sha256 cellar: :any_skip_relocation, ventura:        "801781912be7c180248226557b02ad86700292badc6df1e5a90624a6a2a9b378"
    sha256 cellar: :any_skip_relocation, monterey:       "801781912be7c180248226557b02ad86700292badc6df1e5a90624a6a2a9b378"
    sha256 cellar: :any_skip_relocation, big_sur:        "801781912be7c180248226557b02ad86700292badc6df1e5a90624a6a2a9b378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "856921cbdc231fbba9eab7ecac53569d84455f0452f9225c9082ea5875ba73f5"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
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