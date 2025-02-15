class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https:github.comjoshmedeskisesh"
  url "https:github.comjoshmedeskisesharchiverefstagsv2.12.0.tar.gz"
  sha256 "00261eceb3f27a6b5cf35e821a71f4fea50ce3a5e54f0cc7eef90e68a19b838d"
  license "MIT"
  head "https:github.comjoshmedeskisesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdcb28c1b9115a22d18d8343f0c20c4fec10dcde7813f952c0290763e81aecaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdcb28c1b9115a22d18d8343f0c20c4fec10dcde7813f952c0290763e81aecaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdcb28c1b9115a22d18d8343f0c20c4fec10dcde7813f952c0290763e81aecaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "3221c5621457d9c9b125f3f4a9ea206bc6573b54e363998188878290bbf385b9"
    sha256 cellar: :any_skip_relocation, ventura:       "3221c5621457d9c9b125f3f4a9ea206bc6573b54e363998188878290bbf385b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "100f740377064cedc696e3d065b0a92e2b7a35a58c1a3ce8788acb0dce21bfc8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}sesh --version")
  end
end