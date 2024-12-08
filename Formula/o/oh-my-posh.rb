class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.12.0.tar.gz"
  sha256 "188b5060de286f798e518ff1c45846c8ba6878540c5ec2aca7bbe586c3e105fc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "429ecff16a8f96983eed46650d96b28cf244eb7401c28fef43938ab5956a8422"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a111962864fcbfff2c7cc04da0a21e65cc0dfe0776057f58dd60bd6e30a2b283"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71d3962ed8dff3bbe1f5a53710610fd80493f1cc6f69ba193d737e1acd288d77"
    sha256 cellar: :any_skip_relocation, sonoma:        "49ea0492962af22fe9df26b7ee0bf814c53255bbea523f6fbaeaf3a4b7c01f76"
    sha256 cellar: :any_skip_relocation, ventura:       "4539c95427c71615850cc8288f450a17427bfdcc747e1cbc6933a843568225e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d97bb398484d0cd1273878d9646a0885111378e2a7a894be079692ac88735d71"
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