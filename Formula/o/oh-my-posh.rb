class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.26.1.tar.gz"
  sha256 "d855117eb43f357bb2a49981b06a90dd1184047177c21c1efeecd7164aec96d9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16d4adbe6f5d93ed703dcfea0c6ac110fcca41fc3ce477375cfbb554bcbb8726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f039247c27cc66040557d917550b986197b1623545d7290a2be9b69a9306368c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5822359293c5d8c63c6656ae8b693a4c6aad39b64149c50f0a26216a06b5a01f"
    sha256 cellar: :any_skip_relocation, sonoma:        "05355afc97602fa1f7825ad9d8143ed2876452fd93799c7e05e3e2e6779e36e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2040722876dffbf39ebf6b6df275549fe98ad7144f20801b8a96f4f7352a23b"
    sha256 cellar: :any,                 x86_64_linux:  "4cbca47a1cd334df431ce3d163d68fe4a8dcfad01cf3d92a8f6fe18793a4db81"
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