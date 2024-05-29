class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https:github.comprojectdiscoveryhttpx"
  url "https:github.comprojectdiscoveryhttpxarchiverefstagsv1.6.2.tar.gz"
  sha256 "13ffea88b44fcd603e7226f00b6f68c6bf580ad371e0433610cb92d603b451e4"
  license "MIT"
  head "https:github.comprojectdiscoveryhttpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc5fbc0adfce399cb0d133fe61f0fbf432baa1d267796d16881955f65cd4175d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88cde9b1370363a7a01592f87cd069f88e27f6245b46705851285b31a7964ff7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0626b8810347128a1d50d60968b87ee2b8a113685ed62f201e845ca2e6fbc38"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ad3c1f9920457bace0ae521ad0e6b37e0f3c8c7b20d8a7d71477d1abe4cfba8"
    sha256 cellar: :any_skip_relocation, ventura:        "36f5be728675b577a1f7ffb53f67aa62170be48fa3e3227b69ad6f7859a3b667"
    sha256 cellar: :any_skip_relocation, monterey:       "af6bfa0b471755c4d91535d2237c76957c380e4a47e1436cc857bd85824788bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19407e13d85b33558dca0ec4be42819293139ea1162b3ca11b4ef7932250182b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdhttpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end