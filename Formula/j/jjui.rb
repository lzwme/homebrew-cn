class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://ghfast.top/https://github.com/idursun/jjui/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "2a5c47a411dddea174f1adf7440cf482f0b2c2dff301d141cc50b26374f37ec7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2b858b1c2a18bc103aeb2ed676aaae0ea2194f686edeade970ef100bc12c281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2b858b1c2a18bc103aeb2ed676aaae0ea2194f686edeade970ef100bc12c281"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2b858b1c2a18bc103aeb2ed676aaae0ea2194f686edeade970ef100bc12c281"
    sha256 cellar: :any_skip_relocation, sonoma:        "6585bc0f2f33645aad39df384d1912b03d45ca306ad1655ee65ebb4a4485be37"
    sha256 cellar: :any_skip_relocation, ventura:       "6585bc0f2f33645aad39df384d1912b03d45ca306ad1655ee65ebb4a4485be37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82f638fa04dafe7f6f1ca7ddb15db1aadd8c0a621825d0b95bd71daddbba4f0"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end