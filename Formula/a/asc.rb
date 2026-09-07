class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.0.0.tar.gz"
  sha256 "eb0ef1c66c0ab372ef1a455debcbf3573c505f5dabca88035754bb1260076ef2"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83995782a27ae808443d65f9c711a20c795f208c689c985486c03398e3d2ac31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f572e9407e16bb8c5549151d10db0aafa7b35b00a63380519746339877e1cdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25c8161fc67fc9a901833c753a031c83b4e404d1408680f6662e8c8c5fe0fc0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d860cb49d67e2d3f551ccf39cf6e5a509032dbba8df802beeb638251c0234f75"
    sha256 cellar: :any,                 x86_64_linux:  "5db2bc4dcc0b85cac36c4887121f210bd2e4145ea8f2fcf514a399b0ab1edd08"
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