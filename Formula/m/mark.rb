class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.17.2.tar.gz"
  sha256 "7937d0731d7989e8c55e43cb4def65f4984cdae019aefe7bb8830923a898827d"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9b318547e0851cbad69be8d7fb27fbd5f6dfb2771f823a5a7d1eda425e016c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9b318547e0851cbad69be8d7fb27fbd5f6dfb2771f823a5a7d1eda425e016c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9b318547e0851cbad69be8d7fb27fbd5f6dfb2771f823a5a7d1eda425e016c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00d272ce9f0a0119f7ba04a1e575093619534719472a1e17e6b4718c6c5f790b"
    sha256 cellar: :any,                 x86_64_linux:  "3ce168eae00dec00de1d46a171117d9606dc944d873f35a793e3201542be9349"
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

    touch testpath/"mark.toml"
    output = shell_output("#{bin}/mark --config mark.toml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end