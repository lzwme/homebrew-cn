class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.6.0.tar.gz"
  sha256 "d2214cb6647360ed5ceacb793fa6f8fb9d39eeef7a92a565156e941f75cc608b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3a672dda3fcb4008d3e989c7ec0dd0e666f54da5bc2a26bceff903c35b1403f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75648ce1d424d4176d2239275f25ce38449eba8b9012fe616919d76dc092775d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bac4b9833d196421d1a289f08fa63bc2d0c853abeb842248f5b33157b2f865d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dea2e98690fe7aa49078d6b062e30e979451f5e7f7078460a7cd450c8480d24c"
    sha256 cellar: :any_skip_relocation, ventura:       "d78fba7dc5ed6e75027bd65a84e044f4084d5a541781a50eb45a8f1f326d360c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ec4e36b576a0917a55b827a832c93e767d1bb01a56db4c8890f30f9999be5e6"
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

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end