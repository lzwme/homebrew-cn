class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "4eb54380747d24a1f996ba10bc824fc09d79f988eabe65c0ff50c43e9baece06"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e93de28906745dc1f695880b9a78d9bc655df54f8e1432365948acdef09a6da6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "367ef8a5fb442406e910ee351e75f75b05f0b38b0e29c3875951a0ad3916beae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8d7de0eb63754abbd83ed9f3d796c534c92a567b511fedd5023cd487df1532d"
    sha256 cellar: :any_skip_relocation, sonoma:        "411d529316df86bf3440bbe2f3725ecb5ab3a66d7b8ff2dee39d5bf9c42560f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee0d917b32ef913a45b95667f427fc034878332d563bb9ee1294043765081a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6010759f570051ea4aeee3fc4080318f6f386d0c66a80748a9725da916b3795e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end