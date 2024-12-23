class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.17.1.tar.gz"
  sha256 "c53c8c62bdc116a9ff11a54f5a0a8f9e0ac1ba594adcfe7dbf4941d663154636"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab38444fb385875af8ae339d4302f8c38b1327f72c0c8aa5edd22fee771b8a50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b994abc153bd4ef338bc6e446301b4bc562cd378001c2f1e60fc79f45c2d7502"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2a7a04f3774b51dd3fb61a98f89e44f1dc522443b8f88b603b561124c3eaa8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "178efe0be05dc9a4d37a67de57655a04895b106a94c46998a97b773afd32ca01"
    sha256 cellar: :any_skip_relocation, ventura:       "619a44908baf72b0a129f29bf46763e924d3b29a7e17055beaf0b8a842990e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9a1c67eb8f0f864851e0185f5528ca65c4b0b3b99beacc1306fd81a11aa46d1"
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