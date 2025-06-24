class Runitor < Formula
  desc "Command runner with healthchecks.io integration"
  homepage "https:github.combddrunitor"
  url "https:github.combddrunitorarchiverefstagsv1.4.1.tar.gz"
  sha256 "192665c623bc96ed77f122510510c017197e1673ab92bb84546d652afe4416c0"
  license "0BSD"
  head "https:github.combddrunitor.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5126ca445a8d5515158165a2de556eba26e2371ea5bcf18d4c6b6cd382781f1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5126ca445a8d5515158165a2de556eba26e2371ea5bcf18d4c6b6cd382781f1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5126ca445a8d5515158165a2de556eba26e2371ea5bcf18d4c6b6cd382781f1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0effd12000e9ee680cabca8c05a25dc33df6dd0816d6c5337f22eb7e4b2c4e89"
    sha256 cellar: :any_skip_relocation, ventura:       "0effd12000e9ee680cabca8c05a25dc33df6dd0816d6c5337f22eb7e4b2c4e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "385c34c59826cd643af53842d7517eab4a8315aa21705a7e7ce58cba0782eaf1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), ".cmdrunitor"
  end

  test do
    output = shell_output("#{bin}runitor -uuid 00000000-0000-0000-0000-000000000000 true 2>&1")
    assert_match "error response: 400 Bad Request", output
    assert_equal "runitor #{version}", shell_output("#{bin}runitor -version").strip
  end
end