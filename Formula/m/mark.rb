class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://github.com/kovetskiy/mark"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.0.2.tar.gz"
  sha256 "80a23335f30135a0fa0fa3cae74295f56fe1e6ee6474f64cc0c7b6145573f4e3"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53fb8a8be3b0964ad551c5744bc3834374038f8d6dbd83f9ad4664c2a4e8ce52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53fb8a8be3b0964ad551c5744bc3834374038f8d6dbd83f9ad4664c2a4e8ce52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53fb8a8be3b0964ad551c5744bc3834374038f8d6dbd83f9ad4664c2a4e8ce52"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9ba6d3fb58fdbbfd14574ce569197990d18dcc922e5ad0b7a16267ea837075d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d78e765032742dff4ea0c1ee6d07fd66abc14a6648e259b910e360f9c57d750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a5e7d79fcdbc6a389280830e660d7d7b520891d14ec476c806d3e07122b2259"
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
    assert_match "FATAL confluence password should be specified", output
  end
end