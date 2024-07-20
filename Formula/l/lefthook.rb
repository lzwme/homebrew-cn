class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.7.4.tar.gz"
  sha256 "159633ba5b352f47d5b2ad590e460b562ff35e1d439033479d5686f5f28c1716"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d51e31893e1430fa829deb84883148fbc29f49f6010354e6fcb370b5ba6c83cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c2e3707da31cd961bca3e0d1bcebbbc975f8042aa3e305e38990a9b33539a38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed55dcaebabb152382c720fe41098fbef4c9daec065e4f044e6539e068b503fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a449782adb4bb0036fa67e0c8215fc109301e20a39ded73049415d5559279a7"
    sha256 cellar: :any_skip_relocation, ventura:        "a0e72896bac3accdd5dd94dbaf6f452c2ee364221c4ed2ffe1a35d3a6eeb855e"
    sha256 cellar: :any_skip_relocation, monterey:       "34c72a76f09bf7b1e5749ef56cbe3765b960dc90099951df27dd00a4c3e0bd10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6616c01e3b6e2149a9e70411bccdd94b9ff5d997dcc0631cf3c0a7ba7b2eccb3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_predicate testpath"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end