class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.23.0.tar.gz"
  sha256 "a51432663462ff79318b3ff4bc8d956c8ae0831df9f324a96f58e9532dbe4db8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f77104bb35231eff14435c7f28e617eb911694ccd79f384311099890d690a8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "298f7ea4aec71d3a2d5b0dea2d4adf853f104ebd9ea9fff7feef22ff5e0577d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8ebf6a87297da940d5644c2e01f01749120f9436e7eb77fa6681473649a6dbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e9b5a29d95616a4d54d2a7c6580280f0cd3bf41506e1cfdb43023142fb0a9ae"
    sha256 cellar: :any_skip_relocation, ventura:       "955bf0e7add88f3b83fbd804cbec52c0ec65dba6a0947de0e00cd3303041ca23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7486228f9b18fe6fab6d17544541d7d6737e588833f2fbbf49f9ab52479e425e"
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