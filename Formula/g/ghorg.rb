class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https:github.comgabrie30ghorg"
  url "https:github.comgabrie30ghorgarchiverefstagsv1.11.2.tar.gz"
  sha256 "94a98acdf9b79d9e19b2d91c9e74cf95914634f56a897a59e1c1584a87c9479b"
  license "Apache-2.0"
  head "https:github.comgabrie30ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1847efbc8e869a565fd5d3b0a79b92163d79cda6645244b357bf34f31067fd4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1847efbc8e869a565fd5d3b0a79b92163d79cda6645244b357bf34f31067fd4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1847efbc8e869a565fd5d3b0a79b92163d79cda6645244b357bf34f31067fd4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc3676fb1b2e08d58ed58ef49a47bb319b507cbfcb2b0dfb4d513891c478d4cf"
    sha256 cellar: :any_skip_relocation, ventura:       "fc3676fb1b2e08d58ed58ef49a47bb319b507cbfcb2b0dfb4d513891c478d4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa42bbbec84962ee9e3fab7cc98c6624d9163e7deb74de79a9d59fbc432d535f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}ghorg ls")
  end
end