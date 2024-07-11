class Squealer < Formula
  desc "Scans Git repositories or filesystems for secrets in commit histories"
  homepage "https:github.comowenrumneysquealer"
  url "https:github.comowenrumneysquealerarchiverefstagsv1.2.3.tar.gz"
  sha256 "001683802233e79c2063d866fb7953a36a8331a441a537bd9f7d66c0c10fb92e"
  license "Unlicense"
  head "https:github.comowenrumneysquealer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67cabdd9ed5a27e56d42ae5e7e11f84ce8a8e6d8c122dc907a2e594e100f840e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2444b45b2ab83c10b577953e3b81bfecd528a0b9b1ee6fe90849687916da78f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "261c89ccacbc0f3597b6123604019191b1fdf17635795ec1008fc6348769f1da"
    sha256 cellar: :any_skip_relocation, sonoma:         "52a30dcb323eb7bcf28ff4a6c22cebfd7b1e14189ee937bfc0bab0a4023f1cba"
    sha256 cellar: :any_skip_relocation, ventura:        "5e25732cdaa1567b34973f47eea215c031b04078973c1d79c99b17a348325e22"
    sha256 cellar: :any_skip_relocation, monterey:       "0832649e0602783978553546d21e6af92f4ff6791c05f54586c2d766a63548ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1fea9cfe464827fcec4d3ccb3439a3fc1a0788724c868a19c850526c88a37eb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comowenrumneysquealerversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdsquealer"
  end

  test do
    system "git", "clone", "https:github.comowenrumneywoopsie.git"
    output = shell_output("#{bin}squealer woopsie", 1)
    assert_match "-----BEGIN OPENSSH PRIVATE KEY-----", output
  end
end