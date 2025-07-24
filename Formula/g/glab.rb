class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.64.0",
    revision: "fe60bcf75bfb58801f5a429a52a3461ef62b0f6e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a54df16899adceca1da50cad18d9c877b5397e2f08dd32b4e2482d7b3228eac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a54df16899adceca1da50cad18d9c877b5397e2f08dd32b4e2482d7b3228eac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a54df16899adceca1da50cad18d9c877b5397e2f08dd32b4e2482d7b3228eac"
    sha256 cellar: :any_skip_relocation, sonoma:        "43b5926b28b14d5d7271bd062b4aabaf3af71be4b4471d49d2145f40ef83a2f3"
    sha256 cellar: :any_skip_relocation, ventura:       "43b5926b28b14d5d7271bd062b4aabaf3af71be4b4471d49d2145f40ef83a2f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25c98d07d80d1260c8cd010a96d7377c5283d9d169da89774289f413f4a758c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3e58960c90776f4656b612b02f74b192176e45488dfeae9e74037f705c5a270"
  end

  depends_on "go" => :build

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