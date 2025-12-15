class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://ghfast.top/https://github.com/joshmedeski/sesh/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "403774a6c9d89b093cb491694aeb6ed9eec85575fd80b4482716b5e5f395773b"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a69d2ecfc3a874208cf7fd28573c7bb545ad89d807615b756704fdf5a5f8f6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a69d2ecfc3a874208cf7fd28573c7bb545ad89d807615b756704fdf5a5f8f6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a69d2ecfc3a874208cf7fd28573c7bb545ad89d807615b756704fdf5a5f8f6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fdc9ad454c9324b4e7ec6a66bbf11fc4b3e2834abd391608af0ec54965f757d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5e700eef6ee15c3b13e20cbb64b87c5ca780903cf1aea765e318e3758791b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edbe4d2c1ff1dd0c82a064bd880208acb42b809a166728fcdee0f5fa45239e11"
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