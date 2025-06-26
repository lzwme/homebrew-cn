class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.61.0",
    revision: "ef3ade5e9d4bd7edb8205489b0e29f486b6f0309"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cda2b9771fcea764ab91208a18fc62b2611da62fc3a1ebe9d2efe4b6374e28f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda2b9771fcea764ab91208a18fc62b2611da62fc3a1ebe9d2efe4b6374e28f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cda2b9771fcea764ab91208a18fc62b2611da62fc3a1ebe9d2efe4b6374e28f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb35915da03d1623544dba68e50daf9631d29e1dfded993c80e587ba863e78e5"
    sha256 cellar: :any_skip_relocation, ventura:       "cb35915da03d1623544dba68e50daf9631d29e1dfded993c80e587ba863e78e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39f4bec8fff357377e5f486f349e63f3338af1d06982ac72dd856fba9d762620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7a58547d93b708a64c436028ae02f467b3f125678513381d81ffd2a57ac8a48"
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