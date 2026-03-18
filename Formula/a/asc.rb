class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.44.1.tar.gz"
  sha256 "340e0a518d502eb75c366d629c35bf8747481428f6ef5a6f72c972012c14cb40"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc70e064dff9636d271df190557a07152dfdfdd7ac84bdbf783196115f03bb0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88b949b055c5b65527af57a967268e4a77c69bb9076e0a4ebadfed1692585d4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cebf185cee2aadad229430259a3f6e1491d351ef6b833b21f746946cb8bcb33"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc638f607222e24b49440bd56fd4c903c0ca73dacb6388f7625a20e22e66a11b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09e84ed6a906ba4f952ea6851ef304a111844ef8c97e05afa147165454b0883a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b70288d29a18fb0821d79f50b48d14fe7f3662735ef63bacec0b726ca6c26a9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end