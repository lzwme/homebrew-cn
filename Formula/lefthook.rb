class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.13.tar.gz"
  sha256 "3fd171b64af33df641f4d597427c50ab1a66e6fbdf83caa0607cc1d6c4a70bf5"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d9d1f3c2d6506ddd1ec2f0550f4b39811b15cdcdaeb5149f59ad1bda4a744ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d9d1f3c2d6506ddd1ec2f0550f4b39811b15cdcdaeb5149f59ad1bda4a744ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d9d1f3c2d6506ddd1ec2f0550f4b39811b15cdcdaeb5149f59ad1bda4a744ab"
    sha256 cellar: :any_skip_relocation, ventura:        "ed692fc8c530d51d619e58eb55aaceccd68ed326fbc0850e45dbab2df072a129"
    sha256 cellar: :any_skip_relocation, monterey:       "ed692fc8c530d51d619e58eb55aaceccd68ed326fbc0850e45dbab2df072a129"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed692fc8c530d51d619e58eb55aaceccd68ed326fbc0850e45dbab2df072a129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ee799cab20e2f34851660cb29f3affe0fb2f27ceda315cc78a0b2d9a7c74d65"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end