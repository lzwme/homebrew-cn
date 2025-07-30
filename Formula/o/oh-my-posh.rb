class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.17.2.tar.gz"
  sha256 "df33eed765fdc2d0cb9f0fb54414c2f7393fe01976be6c830aeb204e4955a412"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38924cd65a57373a8a8ea524b64a6c241ba57d14023a81a70bd64b72808eb166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2ffff289ea9d7367d4af7d462a09fc52b3f906777fa405070ed9f2314d7bc2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac550b8bc57f84a2e25a43878a5c4d9929eb3367122d8dea03b54419bd32767c"
    sha256 cellar: :any_skip_relocation, sonoma:        "20a6de308ef33572eea50a84b0ea511c84400f47c41efaf979edc0c899c64da7"
    sha256 cellar: :any_skip_relocation, ventura:       "ac68e248a080664de0614c7e10336396e0974ba5329293a06c66337a54417045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fc0be19465f3913c7671f23987423df563f2a7b2198f434e132ecb6b4189421"
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
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end