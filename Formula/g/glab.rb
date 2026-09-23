class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.119.0",
    revision: "f5016eda261bb7142627d05d1d85a20d6dd56ddc"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd57e1655fa8c4e10f32bbce90772ea301ad860191658777b6064cc52a2628c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd57e1655fa8c4e10f32bbce90772ea301ad860191658777b6064cc52a2628c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd57e1655fa8c4e10f32bbce90772ea301ad860191658777b6064cc52a2628c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e10bd827c7cd6859f60946651ea3e2a5d0049b132ce0c6d202a4720c6ee1816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dc05cf8f096b83b0d31f2872b8bd25bbb104ebacc6375d792085c36135a63cd0"
  end

  depends_on "go" => :build

  # `test do` block queries the GitLab API
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end