class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.27.0.tar.gz"
  sha256 "f531734adc7e0b4efc1b9f595c75078b11d4b25863ecadcac5d29851ab738a34"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d488158f0343e061355bf7881a2e0386fb86200364720e7318e063af22158fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "021c54c0baecb33c35d82f6e9423b708c8c8b2befd332cd86f33cbf2dacc0052"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab357da95c40ebb600d7328a6c72562f65803d720007e6cc9660c9a39e6171e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "3987cebb3e6cdafeb070d54c42cbcb1c0c104ad1a47d97f3d280fd21a7525b82"
    sha256 cellar: :any_skip_relocation, ventura:        "4930afbfcca0ff1b9850eaec2d621d2d4606d598a2472a9a30f5b1625b6d6b00"
    sha256 cellar: :any_skip_relocation, monterey:       "36097a6f628a5938b9944a9f132b5f8f49eac9f2f3b00bb164ad2b5f2b23e70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0760092eadcaadb85f8d9bc0eaca22df8c00a08d14fbf581948fc19d0f215d63"
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
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end