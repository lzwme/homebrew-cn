class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.60.0",
    revision: "8056b7a3325097aadaa11272e76477619a28bdaa"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d4aa510d8dca7810b2cb5755554d31da52a8b0c25314b0307551805a0de8ef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d4aa510d8dca7810b2cb5755554d31da52a8b0c25314b0307551805a0de8ef2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d4aa510d8dca7810b2cb5755554d31da52a8b0c25314b0307551805a0de8ef2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8c1b77570e36a810673f25000c105410e9c06c36c6abfe8633e30ddc79ae9b9"
    sha256 cellar: :any_skip_relocation, ventura:       "c8c1b77570e36a810673f25000c105410e9c06c36c6abfe8633e30ddc79ae9b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1d5348b03a6ce0ff2e766ca5b5b89045981f624c12c3c7270d147c541aa5055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04b3859cbc70afd4a1a35448b970b45d4eea78b531d741e67602558d0e0e51e9"
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