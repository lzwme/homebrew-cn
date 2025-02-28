class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.0.0.tar.gz"
  sha256 "3a82c04bb57b3a67783a99cbdbd7ada17011d8df4f99ee1900a65c5282bc1226"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e867def623ccd22577b395c25adc8c90fe799a41243a1a6c6daf7e574b6adbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9535a44586d35da6ffd3a4e40b020b6f691f9958e16258ee69617d0bb7728bf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91841433620118f40e9b272b9bf1f79bc49fd653184c1898b2fe901bdbd6bc5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0336f028bf88795e9a177fbffa06973d4a716802cacdadf460828bba35d7031b"
    sha256 cellar: :any_skip_relocation, ventura:       "071b008a5f211d0f78be591983d160f77e613cd90728e8d6fee38f747c4bbca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6961c319c82a774cfcd6a05f292824a9b95d924322d3a0fe274aa54fc1a14d4"
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