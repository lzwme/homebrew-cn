class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://ghfast.top/https://github.com/joshmedeski/sesh/archive/refs/tags/v2.24.1.tar.gz"
  sha256 "c31cc7be55fa0378a9d2c0663c19d096021728aca74ccaad7c42c0c775e77ccb"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4eb0e1ec04d29b579063eaf98cfcbc3181d8043329dacbc659cf3ee7a62b423"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4eb0e1ec04d29b579063eaf98cfcbc3181d8043329dacbc659cf3ee7a62b423"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4eb0e1ec04d29b579063eaf98cfcbc3181d8043329dacbc659cf3ee7a62b423"
    sha256 cellar: :any_skip_relocation, sonoma:        "853ba4c31e74cc1012815aae487d981c4e8ad9e30666416aecf58f3c2ef4c36e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eefce172a88f086a44890809c3d52b94e05052249dbb4ef9ca2dc73626bf1e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b2f55f6cd14de874c86bc8f69eef1b939dee1fba2eefbadc5d14e815690d11"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end