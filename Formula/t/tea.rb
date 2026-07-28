class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.15.0.tar.gz"
  sha256 "ca8a6b39116617dac2bb46b53cd4021daea6a7ae6a8106fa6ef359c76b54118a"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e5e15e83f11594090d8de83745bfa0fecfa9681352ff5b3d8879147b290be45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e5e15e83f11594090d8de83745bfa0fecfa9681352ff5b3d8879147b290be45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e5e15e83f11594090d8de83745bfa0fecfa9681352ff5b3d8879147b290be45"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc93405a375d26bb56fbd93ffc819a54c1811b324514c6744afaf8cd40307579"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "838c8e1c2254390e9e21e4664777a650d53cae76b9690a61385ca0275bed4cab"
    sha256 cellar: :any,                 x86_64_linux:  "0cfe9b3c6909e77ecb5b067b9eaa327c5119aeae46cfd73b8ae5a358db245a0e"
  end

  depends_on "go" => :build

  def install
    # get gittea sdk version
    sdk = Utils.safe_popen_read("go", "list", "-f", "{{.Version}}", "-m", "gitea.dev/sdk").to_s

    ldflags = %W[
      -X gitea.dev/tea/modules/version.Version=#{version}
      -X gitea.dev/tea/modules/version.SDK=#{sdk}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"tea", "completion")

    man8.mkpath
    system bin/"tea", "man", "--out", man8/"tea.8"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tea --version")
    assert_match "Error: no available login\n", shell_output("#{bin}/tea pulls 2>&1", 1)
  end
end