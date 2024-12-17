class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.13.1.tar.gz"
  sha256 "4813999fec4c5ab4011d1ad800598afc92459c685dafa0cbaaa9ab6aceefad68"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a95452cfcab28735cf2b6a5fc1433ab55e1d817bafbef0581b4dc49291b7fd0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da0880b22ab9a6375ad7c8a26e3ade2c58da3d4a718c55f5bf0a880ca16fd196"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "206603d96187f1adc47fb8a5793b3d44bff45715ab0c83a80ed58b34d32716c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa083938a2c71d9898ad2b81a2c184d3a9c1570f52b3c9de9a0fc66d46c6dda2"
    sha256 cellar: :any_skip_relocation, ventura:       "fb562e91c77a894793bc6efcda19d2b5a1d9b1e64ecdb476ff557be1dc6b869b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c16e5cc46b6bb3dfe6903867004b93973bcde2970fe18e7a8f8af0d1f28288"
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