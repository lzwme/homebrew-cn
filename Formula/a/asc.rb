class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/1.0.0.tar.gz"
  sha256 "2ca5c81a56d0227df6dc0c709c4ebb444a73ba3d3cdae94a8f1150511e1fd3bf"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f368016a64558276622d24a80f93553483c8292cd016ff6c763f7499f928ce0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8716bf26119e7d716b4cf08ddb3c816746fe71dd540492a8e81e89fa7d31e3a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54e93819130f3502e67e66d5064993a8b5e4beae3fded0e09850a5704dae1fc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6f710f95bdd7df2d6d53fcd64862df52d92a4cb8e8c211e299f3622d5eb04ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9f4ea03ade9101fc3ab36b2cc17ce9c79bf55c6ae4a7a2113f24cbb4c3c4c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21c62ce2ecf844c3fa1e570418581155db0dde4699798986b60f9194e9a1450a"
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