class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.16.0.tar.gz"
  sha256 "8e19bc0ed631b5ce9be220e233afb38fee3a9122c8ef0b5557137af00b482e7d"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5212710a8a127a2c0abdd9d300a2cd64a202594ad6c8b90b02a9d1523c69674e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11d6efe52337afa36890b625cdae20b6eabad3d9a4adb0a36f132b64b38e88cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdfec8cc387336a960cd62a4741546135a255168b684e092d7dce43a999d440e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3a9b9fe745fc0ed688ffbeb040659cdd3432898da3add71507c36c1d2e565dc"
    sha256 cellar: :any_skip_relocation, ventura:       "ee76854b06577c487753f6b2a96a1ea172ac9fb88095b77db97d80985f9306b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e9351d28e069dce3ddaf506e709644b9e08410d22e85fadb2dbfbe3e3a551d2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin"oh-my-posh", "completion")
    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end