class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.8.10.tar.gz"
  sha256 "1fc2f87429f1e79dea03042da45da719c2da2dcaca793e2d9e366c79ec6d5344"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b696c1e69138855873567f229465e15ece4971eb69212ce5ce87dd9b2af9625"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b696c1e69138855873567f229465e15ece4971eb69212ce5ce87dd9b2af9625"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b696c1e69138855873567f229465e15ece4971eb69212ce5ce87dd9b2af9625"
    sha256 cellar: :any_skip_relocation, sonoma:        "c15c23c14669302e815cb14ef71d81d7cd6bb199ef9fa545fd182d54988d7f1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54d461318caa6d0b6d724608e91179b5eee4388adb4fdf15c020eb534af9f633"
    sha256 cellar: :any,                 x86_64_linux:  "afd7ab552c145af5e0e43bbe1efd0e8ef82d18da26400fad96c91e09a8772259"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
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