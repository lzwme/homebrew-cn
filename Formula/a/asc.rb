class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.0.0.tar.gz"
  sha256 "0d3291ad14ced46bddeb0204a9103f3bb5ad489c491b35b6a8ee9a0fe99b4296"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "665c7bf05eb3c5c34f7cc23f97eabbf8c231efbd6c21d98f58a98990fd0ab337"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ee5bf28cc2ec84de69e4101fb48e13efcf063779437bd29c4b67f152bcdbaf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15c7ebb24f89f0863c27f1ae94e50e29299796ffafe207319b9297b223a8b988"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5455309ef8e6143c15c6e8a7b683b53d3a632d62ac1f30598d19ccad9b65d7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0e06cb124e222d635fa0e4641d841b5f1dcbad46e1d790f19f3b5350a8d6ecb"
    sha256 cellar: :any,                 x86_64_linux:  "5b655316bfc60d2fd7a9e7cfea906b8c63ba5ff72f6f578cfd5d6d36d672a58f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
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