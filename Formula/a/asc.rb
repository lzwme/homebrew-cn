class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.1.0.tar.gz"
  sha256 "29509591b2f559d20c449885df7605cebaa4dfd77b8822f4906a939776f5f980"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62778c15d25988f3ca5d722d888b89a86d51e22807fb1ced0fee30233d38f7c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aecef90b9b8d9b8c8c353fde7186bce6f5493657dd7259e67e7cc14d0e89a69a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c91c216b6a4a89b68cdfb4bf05a6a4bcff7d5f283bcc7ca7b93fb5298f6cd8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e7e70afdabae30377410ba41be10f949ec62c8ee89591a922127788042bb9f5"
    sha256 cellar: :any,                 x86_64_linux:  "ced459d06aa9d5056b1a6639d92f86d3c574bd9892a707aed54b91b54339911a"
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