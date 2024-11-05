class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.0.4.tar.gz"
  sha256 "65eb296f419a409df9f8c9f09313f186164e3f0efa77834927a1862ea7e39f24"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "771a98fbafc74247601f050983da2192014c48bc5a6c87de6d78b6d8108288d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef087f784d4d2e4a84d17f6f8f25a32720ad22515ba6105b2c03ac5df4d56b08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22599653b94b3e44476cea76ac78db6555501b130ccda05807cd5880997e8bef"
    sha256 cellar: :any_skip_relocation, sonoma:        "25ea380c4e562e5f69ad91e73670d795fecc8e7cab7db7f84b8f7fce8b55b8c8"
    sha256 cellar: :any_skip_relocation, ventura:       "3fabb266165b14c39da1ce2c4887d759b147ce8220b1346e2e5c749aafbab9a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc788fd0a2b3696b278d393b5f36606287d4e03f8cef5f5eae2eff273a79c88e"
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