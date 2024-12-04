class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https:force-cli.herokuapp.com"
  url "https:github.comForceCLIforcearchiverefstagsv1.0.7.tar.gz"
  sha256 "f3a37692bd5f1dcf842ed3d917523b13c561ecfbdfa5170f4e98789c6472d762"
  license "MIT"
  head "https:github.comForceCLIforce.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17f239689383c786aa5401eea3affcff723c30b42dcf7da74dadf054d4b15eb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17f239689383c786aa5401eea3affcff723c30b42dcf7da74dadf054d4b15eb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17f239689383c786aa5401eea3affcff723c30b42dcf7da74dadf054d4b15eb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bed56cb88694127de8c563300801f6c9a29b0ff81485472e11f95b6ab7215062"
    sha256 cellar: :any_skip_relocation, ventura:       "bed56cb88694127de8c563300801f6c9a29b0ff81485472e11f95b6ab7215062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "597ef7a0ba05cac67e45f7cfd8c05537a194605c8e98d75ea569c88795e1ced8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"force")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}force active 2>&1", 1)
  end
end