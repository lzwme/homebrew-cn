class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https:github.comprojectdiscoveryhttpx"
  url "https:github.comprojectdiscoveryhttpxarchiverefstagsv1.3.9.tar.gz"
  sha256 "b279ab46a2382434894959eddf36a46d20f22300f870d2e11ff65e16b781c88b"
  license "MIT"
  head "https:github.comprojectdiscoveryhttpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0158e06659771a85ea31b5cfb9326dca4af88a13bc9351f1896500b781fe33a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8dea8b526fbe31dd24b1da403804e1c21e4d594104669a78a386e2afe24847b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1102d611059cc9bc0744aa4b7c9ef9f1ee0ddd6079ed06de349a5b9b82a0b7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba2db5f72c3a8451111ea6bdb2a0bbe8fd763c3fa52716506050feec4a6b3fc6"
    sha256 cellar: :any_skip_relocation, ventura:        "69d7b8a6a8c09706a04d1663f5fd0c1d9494c3694487c1af20806f2e01a39e60"
    sha256 cellar: :any_skip_relocation, monterey:       "7f108b72e9e55ce260579ff13b7efb0ed4711eadec9c3d8cf327ec3e2eb9d489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ae5ececdf482c141b2920798b67beef93881a60c8745492ebc7fe43ce49154e"
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