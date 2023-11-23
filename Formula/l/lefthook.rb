class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghproxy.com/https://github.com/evilmartians/lefthook/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "1fede712539e716759a5f519a542800074d9c668b110044a7dede6ab9a06888d"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92ac29e332a64fe9d9b49553a9e1afcb38e09504389f2e8dd0d25d525d44ca4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb4c4fcfc57e79c92eb4a727396f898f26fcf4c63249ada7aad8a7d76239f96e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fb1a87dac80370f6f1020dfe8c4bb1d588e1e9e4d223047046d312cd0b0aed9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed8c31a39a0e11450b884f955a1d8e37179e7da2239427988b119533bc9d252b"
    sha256 cellar: :any_skip_relocation, ventura:        "3da19f0cb26343e9adac1a9187adce657276d7374773e3c0599aa19171e0bffa"
    sha256 cellar: :any_skip_relocation, monterey:       "117d64b3754521983915891169450a34f3e994617ffb2a61e47458947f9e30c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b720291d328271881bd5d25c1e8ed85aa628a1adf3e83a037a858f736ac4773b"
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