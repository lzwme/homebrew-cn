class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.190.tar.gz"
  sha256 "4c2cf147a69f34f414f78f4ac2ba37e2af51ac93b22fa25bab8ea7017d46a5dd"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b5435674963212347db215cdf73801beb6ee8e6ced1187d58643fd812d73123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b5435674963212347db215cdf73801beb6ee8e6ced1187d58643fd812d73123"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b5435674963212347db215cdf73801beb6ee8e6ced1187d58643fd812d73123"
    sha256 cellar: :any_skip_relocation, sonoma:        "f900afeef728bd136de578550440b4a3b526ad64d76fe023b3e53065e9b0b8cb"
    sha256 cellar: :any_skip_relocation, ventura:       "f900afeef728bd136de578550440b4a3b526ad64d76fe023b3e53065e9b0b8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7f686c57c375a68d6211daa29b19ea12e59f4290eb2e0b186c87ed08ff7b302"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end