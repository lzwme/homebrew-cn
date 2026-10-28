class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.125.0",
    revision: "685c1cbd74c882e0c93d7011657adde811582ed7"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a5125966908901953057ab75dc605e410e45008b617e71d9e18b388aedbab763"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a5125966908901953057ab75dc605e410e45008b617e71d9e18b388aedbab763"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5125966908901953057ab75dc605e410e45008b617e71d9e18b388aedbab763"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "452d404e038a9b159579e4846adc8b6f836ea74f1794762972edd8c2c6a04243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "29962a6e870a6b057807e182facb0e418bb3b83186769e4297e2de50465e1a1a"
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