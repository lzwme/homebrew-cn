class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.29.4.tar.gz"
  sha256 "710a81edf4eb0782ab2156d7a57e34d08fd3d4e244e97183267499160799a64b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4ca8640ec4d3be4e65e0ba42323180dc0ee9cc079aed31fe90f0db67b8b934b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "064ffce6256825664569e3bca5b113068a52ab21a767b6bc65c60b76df805250"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acf6c2a56254013d28f55a811dddc1c741b12df3f0982f7899992c9364f5d234"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae033449cb0fcd2a205ae230d2432d586a598b466a9c101143b9d5c482b1ad28"
    sha256 cellar: :any_skip_relocation, ventura:        "12d41a1aa3ebb1eceb6a3130f013d608eefd51bd99cc9edbf8bddab60d8bb2db"
    sha256 cellar: :any_skip_relocation, monterey:       "8266d3de7db6bfbb76dc3e3f3ea1a7ac5cabd49294ea216dfd967c9ab0f28355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "349faa1b7f344948aab75488b1739d014159c04e8116851a83e588f46ad5afd8"
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