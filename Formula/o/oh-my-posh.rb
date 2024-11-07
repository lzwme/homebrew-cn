class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.0.9.tar.gz"
  sha256 "d58609cb875ff8ca1245b1b32a955328592d053fe45123dc60a7047326d352f1"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48f14bcff144758a08cd2284d2874353462acc425d2031d58f6a31bb81a8e562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9d677eab7f7cc010ce7feb8bba30804aaefee212ba0323a02a4346f395689a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd84e1551c9011c114bc22f977c9012ff825d58ed2e89e595194a2eb3077a6c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ed2af1afae7762c5ce84170909e2d86414b78649c11dbd271f4c48486c0540f"
    sha256 cellar: :any_skip_relocation, ventura:       "727a55b11f79a16efbf81def4b414488e142aea00cc4f5a6e0e3cc7785230291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b444175b632e32b6c39ae9c6a27143542c134d1f6986e7c3f563f1c93048ff"
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