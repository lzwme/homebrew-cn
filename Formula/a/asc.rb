class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.5.1.tar.gz"
  sha256 "6d8ce13fa6c15cff1ca3cdc7bd9d4ac5d42696800abc159e842cb4d8e60fc87a"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80d8ca0fb351a4f5fc2109b7c917a57f7513559ae5aad2f3a310dce4abe1ae1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6c2bf9090bdb20f48522694a0cce1583500608b70d8bd9e845cb10f08d64915"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d086faaec01fcfae01bf8e39c7af15cd0508894bbe905bc8233962f51e88264"
    sha256 cellar: :any_skip_relocation, sonoma:        "7439434d5fb6c87353c11ba1b7173349c880b1ed07280fcc9bfb1fa4e4014007"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61d46d4c016120c0d13d9ba02c66a088d5f8e1af579d1ab93c26052c3a86530d"
    sha256 cellar: :any,                 x86_64_linux:  "5e00cde4ac51a4257039a91c1f47ad7d497474d1e5f94bc651860dcbe40ee05d"
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