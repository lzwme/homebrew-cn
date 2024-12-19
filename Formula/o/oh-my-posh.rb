class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.15.1.tar.gz"
  sha256 "20f9854fe646d7c10769ff97c6fd9fcf5c6b896bf6175725f53b65e1db9c8d8e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4536e3848bf6868fe9c084fb92123a39e1065c58fc551d3e0271b6fe325a83c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99b9ac215572e02471550d41492f2f124d940ebf73101e8db1801fe512e37f7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d581f275bba8e9d0555d3c66d5a8284e5f96db3151be78f9b8d8260047c714d"
    sha256 cellar: :any_skip_relocation, sonoma:        "672972f77877b694be6db7079de48340e7e3a7b2439c47f0816d05300f4fc61c"
    sha256 cellar: :any_skip_relocation, ventura:       "2d328272032e6d1ea319679f8f007212a0b4389045906f461adf4ac0ba4f6092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985638d26190cd672adb018eae1b9f4b65311549a1a21a6965708d961c97d8be"
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