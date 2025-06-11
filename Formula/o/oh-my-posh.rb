class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv26.6.1.tar.gz"
  sha256 "05db7918c355b0ca735dda3b48118dc2c1bfd92d56151ff55e92a2dbcc97d072"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eeac8d72668dad37e55d4b7bf22fa178d5daf712c6555adfd0c7440216c6b0b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbd73a9d591536450e70bacf14e131b20c51d954dd9ea7a06a3798415df0bbbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7bffa210709bcb8637a4d4bc90be074b4261719252b5abe5a414d5b6a42057e"
    sha256 cellar: :any_skip_relocation, sonoma:        "af175aba23f61ef2ff0e47bf680d0350324096da5d8fda97f61b5ab4189995af"
    sha256 cellar: :any_skip_relocation, ventura:       "52c7b12255f9295905fa74eb8941c5e245d62922476df81420d29a0f67ac0c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78d4c82ea1f7bc18b421d17a95d12f9109fc9001faf4c863de4e7aab481bc54f"
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
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
    output = shell_output("#{bin}oh-my-posh init bash")
    assert_match(%r{.cacheoh-my-poshinit\.#{version}\.default\.\d+\.sh}, output)
  end
end