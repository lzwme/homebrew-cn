class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.2.2.tar.gz"
  sha256 "29baace3027f0733e638ddde11b299d89f6968e2255c223c71961bc8ef597570"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "533572e699793714e61e9d9634ba085ce97c14b786aa640ce9d16779076bb02b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d67cde899cd3ef91863287cfa65731a3070066f00c144cef007ecf09b75d4ce5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18ead670d63e7c3a1afb9de60e3b3b60e836e5f19922696660c71e85397e94b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac6d638bf72bc9166e4e743a29f0de475d322edecf1b5f72a1fae139c12c2746"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a28be9d5d351c5e13f59bd8406e8b5e33232521c83e78df1b277ead2923404d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ba4fbb6a06d052bcff434a0d2b74ff34a8d9ca5ed8b6d875f9bb753645506ad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end