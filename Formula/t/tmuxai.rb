class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https:tmuxai.dev"
  url "https:github.comalvinunrealtmuxaiarchiverefstagsv1.0.3.tar.gz"
  sha256 "731bd76515d3ddef1d8c9582c5e35fb382c3137a97b72802c4ea8b1da859c97e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55d4a8c91e2772bf0159ed9f63a255087d1e21dc3cf12ede72887b6e17adc04e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55d4a8c91e2772bf0159ed9f63a255087d1e21dc3cf12ede72887b6e17adc04e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55d4a8c91e2772bf0159ed9f63a255087d1e21dc3cf12ede72887b6e17adc04e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc419d5dcb50402bf071f00f9112b68da0c4ae2b4e4f5357e0ddbfc99268352e"
    sha256 cellar: :any_skip_relocation, ventura:       "fc419d5dcb50402bf071f00f9112b68da0c4ae2b4e4f5357e0ddbfc99268352e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77e46a4397400f17067529630e7f0761fb13ed7a9cfce5f69e27e2317f2f84df"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.comalvinunrealtmuxaiinternal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tmuxai -v")

    output = shell_output("#{bin}tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end