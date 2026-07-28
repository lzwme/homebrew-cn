class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.8.1.tar.gz"
  sha256 "3f01e975bbfe8fa563c900411347477438dd068512023c0fed602acefe6c1442"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "923e6326de6b9f160c2bade7206bf598c9ea2b3eec2962cf8cb378d141d6f7ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "923e6326de6b9f160c2bade7206bf598c9ea2b3eec2962cf8cb378d141d6f7ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "923e6326de6b9f160c2bade7206bf598c9ea2b3eec2962cf8cb378d141d6f7ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5f4401ebf02145f5d38fd2038b625d8012b6a720ae332b78ae54052c4bad2f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3438a02c563bc290d1e7fe0eebfb236c8f4147409bca1901b7a55cf7e0c140c"
    sha256 cellar: :any,                 x86_64_linux:  "adbd5cfbdd57737975c9c70e631ae9189a9c97a4d01d11f0735308f83897d6fe"
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