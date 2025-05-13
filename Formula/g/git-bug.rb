class GitBug < Formula
  desc "Distributed, offline-first bug tracker embedded in git, with bridges"
  homepage "https:github.comgit-buggit-bug"
  url "https:github.comgit-buggit-bugarchiverefstagsv0.9.0.tar.gz"
  sha256 "4f9a8d77b0c0e10579d9f28a1355e2d349b0ee83da282daacb17263d40fe8c77"
  license "GPL-3.0-or-later"
  head "https:github.comgit-buggit-bug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e286e1832a989871e804177185e0bb01f78e89ef90ed641e0d02a385034561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1857c592fa829ce895e10c93a8b6185aa5e842b1881e94c3ed27782b7637e9bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e23568875bdeeffbb7670351188452456a842f5d68dc262ba3b882b0568bd75e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb78a0c77cc633d5f12112e727018a09c7d03f628034394ddcbc54dd018f34a9"
    sha256 cellar: :any_skip_relocation, ventura:       "ae66e5b09de6a4f2255274ccfd47372a9d59980185e37181707ba14648fb89ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbc94d27a35a9b46d8368421d80cfeb18f26fcea6655fc41d6fd9b6c49035a6c"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    ldflags = %W[
      -s -w
      -X github.comgit-buggit-bugcommands.GitCommit="v#{tap.user}"
      -X github.comgit-buggit-bugcommands.GitLastTag="v#{version}"
      -X github.comgit-buggit-bugcommands.GitExactTag="v#{version}"
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:)

    man1.install Dir["docman*.1"]
    doc.install Dir["docmd*.md"]

    bash_completion.install "misccompletionbashgit-bug"
    zsh_completion.install "misccompletionzshgit-bug" => "_git-bug"
    fish_completion.install "misccompletionfishgit-bug" => "git-bug.fish"
  end

  test do
    # Version
    assert_match version.to_s, shell_output("#{bin}git-bug version")
    # Version through git
    assert_match version.to_s, shell_output("git bug version")

    mkdir testpath"git-repo" do
      system "git", "init", "--initial-branch=main"
      system "git", "config", "user.name", "homebrew"
      system "git", "config", "user.email", "a@a.com"
      system "yes 'a b http:wwwwww' | git bug user new"
      system "git", "bug", "bug", "new", "-t", "Issue 1", "-m", "Issue body"
      system "git", "bug", "bug", "new", "-t", "Issue 2", "-m", "Issue body"
      system "git", "bug", "bug", "new", "-t", "Issue 3", "-m", "Issue body"

      assert_match "Issue 2", shell_output("git bug bug 'Issue 2'")
    end
  end
end