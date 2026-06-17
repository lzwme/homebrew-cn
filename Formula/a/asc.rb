class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.1.0.tar.gz"
  sha256 "25a87ffbccc0782a1958a16052f276a541b4a3973e2b220dec6ee0fef752d8b5"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e76f33ab9be6a72c29e5cb7a37e5a7a7d3cc2bdc7ad0ba7f9742ae4532db84d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a71b350ef191db6edab1704e79f314bfaa66a1a78f3b0748a90797ba1e04e7f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "268c741379458cc85af58b805cb32a4f10c27b4a8f99686b5fcd8834cd6b7527"
    sha256 cellar: :any_skip_relocation, sonoma:        "668220675746d2bff32f45356b2788677deef715b49bee2e5cc6a7d22943d549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb5771de4e8f2d84d7c503ee4ad4c30bf7847bf6e14ece9cb331fbfeba8d5ba"
    sha256 cellar: :any,                 x86_64_linux:  "5772d80de407e8ce8ed7f3c4c6a62b23f127fc454fc1a925907dee2a22b2c595"
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