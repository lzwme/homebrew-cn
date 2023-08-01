class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "79ec071e9bbf200ffa3aceaf542425ea89a7dead1803aece7320861eefe5688a"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68d4976bbe876c6f64b173d7c6b687b082fe258f904093e57804fccabb6bd6f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68d4976bbe876c6f64b173d7c6b687b082fe258f904093e57804fccabb6bd6f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68d4976bbe876c6f64b173d7c6b687b082fe258f904093e57804fccabb6bd6f0"
    sha256 cellar: :any_skip_relocation, ventura:        "7fc715f9291fcd08aea37e03d9deb568c8ad1ab560188459a7b02663389a488c"
    sha256 cellar: :any_skip_relocation, monterey:       "7fc715f9291fcd08aea37e03d9deb568c8ad1ab560188459a7b02663389a488c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fc715f9291fcd08aea37e03d9deb568c8ad1ab560188459a7b02663389a488c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2156ec2ef2aa5a1703779b38ffafbf684bd7310e5829d9ddfb790ced975786ed"
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