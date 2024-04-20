class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.23.0.tar.gz"
  sha256 "f4181e4fb2b3279e5b3caeabcdd4951005a2e0386582b0395755e38be4344109"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01064a6282f97602e1eb6a7187f309b3dc75b2890e84c9487dd7346503a035cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e0887498b21391c9fbbcd7f435e90e051c62a77afbdabc310977a2cf6707d19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "815097c5ec4e8f92eae9edfd7062c18ca2e28d2c8506b625b6be71fdf7850b7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "722ea01064d4bb2e1e4f11673a10d972f7660519fdf76b79ee0b1386f0cb8e10"
    sha256 cellar: :any_skip_relocation, ventura:        "4d75de98314bad5d62d840a520d39bfe0d0a23fb72d3d0608cc27bce13ca7856"
    sha256 cellar: :any_skip_relocation, monterey:       "de9629984705774b6b9e8c5714fdce1610c40ee6fef1e5eed41c75789340866f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32722b317cdaa1a4a9a86cd8630b89a60c4aa0057e5f92255948cff8a2b68362"
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