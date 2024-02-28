class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.6.3.tar.gz"
  sha256 "6fda768d62b951b33c76835c1378b3d1595aea85adef880461ea8205d5aa099f"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9542a918d8d5d2f45d71bdcaed63c2cc4559113128a493fc8401fc4f23bb9812"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b195087fcc6ed6c9d078fc32de48bad055f9c1b1bf0c41adc461532660c01223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d754ea71ba9ccf32ecf1843eb03f003ec9c8f597a72625cc8c6bc5cdc594c476"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cde6a8b00ebd015d05b2c7c028bc805e7ea47709816d3982e4c8123b1ca1b49"
    sha256 cellar: :any_skip_relocation, ventura:        "36b2b2c34bea87dd39846f00d14dc0cf201c90b6cc027f13d538036c4b4e7592"
    sha256 cellar: :any_skip_relocation, monterey:       "de3689633073bbaa0058a87a65bb65b11682344d03902f5b3cc8c2dd6d457d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47be02c89dc606581873f31c7fa00c8916b2ac40bf6e54c7985bcf2abc15e864"
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