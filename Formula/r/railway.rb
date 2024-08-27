class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.13.0.tar.gz"
  sha256 "6d1357709bec787d066b8c10d127e9da79126e492a4dad69a7d2abdc41d28281"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee6ddf95cdfc0c8044f7707a2ca211baad6e952dc403d137b09037d6de0b065d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c475db48493ed1bf6237f6e0a9dde072157531c6817d6ff40978584c5e18354"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e0f17659ca42754a09afdc2238622928a89e680f54e7341ba01feeac2f517c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5eb75bd42e513adab64594dd8689cb49715ad08312c85ee0ef8d79b6d3197eee"
    sha256 cellar: :any_skip_relocation, ventura:        "9e7c5e66808dabd9e4819f541795a333d63d622cf5d10dfd6e92642524a31161"
    sha256 cellar: :any_skip_relocation, monterey:       "aa83021709654ccfdf1b3f4cd061ec9e736b39fcfb901d503c6b1cc16c396919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9d1989ab8be4e1e0295a9e4c35a831bd0536e7ad95f31ad190cb9533ec10416"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end