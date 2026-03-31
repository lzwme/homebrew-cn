class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://github.com/kovetskiy/mark"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.1.0.tar.gz"
  sha256 "eb92e265d1a92af4f0f6f552fdcf33a88bfa637238147a67fc699e5be96b47f5"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b3179e20323649da15c2a0f124c8e4b4f1d11ff3dd03573c400762761781a86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b3179e20323649da15c2a0f124c8e4b4f1d11ff3dd03573c400762761781a86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b3179e20323649da15c2a0f124c8e4b4f1d11ff3dd03573c400762761781a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3d145733610e63845acb0f8b727c68b3df8efaa688be8bf6a7d20f8d426889b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50e06c35eedb0c5a1df48131412cd2f25364c9ce2495060d8c30e1446cbd4699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8656edef0eee9c54667b94eac1fe6f7a366afac38e584be21787da7c0e25dc5e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end