class Gitmux < Formula
  desc "Git status in tmux status bar"
  homepage "https://github.com/arl/gitmux"
  url "https://ghfast.top/https://github.com/arl/gitmux/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "55ab3c3bc986ab152873f8d24ae69d43855151c0946aac4fc1a2609f85a2f4a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cd6c37922a9460a4612bca6839a41f387c80fca28b0d6ee84bf48feb57d8563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cd6c37922a9460a4612bca6839a41f387c80fca28b0d6ee84bf48feb57d8563"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cd6c37922a9460a4612bca6839a41f387c80fca28b0d6ee84bf48feb57d8563"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf41229b2b60809f46d35af2166a21cb73be51676cdde08e8825665c5480e3e9"
    sha256 cellar: :any_skip_relocation, ventura:       "bf41229b2b60809f46d35af2166a21cb73be51676cdde08e8825665c5480e3e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6ffa9c1d1aa3f068f08d09cb4bf1bded2a497532a7f49e4b43cc5c163c00f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb7a56c24da802d4ba060af17fe859c738cb27ba7c62441cce3fff0ab35b698f"
  end

  depends_on "go" => :build
  depends_on "git" => :test
  depends_on "tmux"

  def install
    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitmux -V")

    system "git", "init", "--initial-branch=gitmux"

    # `gitmux` breaks our git shim by clearing the environment.
    ENV.prepend_path "PATH", Formula["git"].opt_bin
    assert_match '"LocalBranch": "gitmux"', shell_output("#{bin}/gitmux -dbg")
  end
end