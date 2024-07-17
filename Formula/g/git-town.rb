class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv14.3.1.tar.gz"
  sha256 "7de12e299f22bbd86ad6c11ce288f2bc1cf20c78c0e04aea509795753d1ee967"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e80714e7df9714f5f5735362cdd87a10690a51ba4449a79e3821ae188be38cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db8c3b731ce26c6bf6b1b7a71022f41f23d753242bea724d7eccf653b5df19e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b361e65011b71ed4ea6bc1accd422ccc87c74bee5b5b078e7751a8fe550a6e48"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff818e0016cb76b9589c96e7beb4e1872fc0be3dde4dfed2eef657fc85c71b63"
    sha256 cellar: :any_skip_relocation, ventura:        "2f0e4e97716642faf1f2981927e2318657cee26974504e288f04e3b65223b002"
    sha256 cellar: :any_skip_relocation, monterey:       "23ef0d6553a684c92763b3f1c931fdcd302df943bd430331df7ed8771dda0431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8a0d7a05430db045f5729262cb37d668f2174832b1e9caa38d70dbb378a97f6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin"git-town", "config"
  end
end