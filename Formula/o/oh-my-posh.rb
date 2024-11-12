class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.3.0.tar.gz"
  sha256 "3e192e84a76349e31de5292244954aef5b5b5079ef68deebdd96fd06cbff2d2e"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e80e5703ef5e1f2e267126540bfc362ca8727cf02b3148008b00b5086b7bdac9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d536c067dece5fd5220827c376a52c334198aab14a0e9d4e7346af3049496e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f40f9192188cd8fe4eea235e7ce63d24f50d92cb31b1b18c550b9a9421d1fe46"
    sha256 cellar: :any_skip_relocation, sonoma:        "65d6657d4afd7c1b3cc99418282c503213927c3df09318038fbbc827a031d4ac"
    sha256 cellar: :any_skip_relocation, ventura:       "a60c695852248c98cd36bc56160c974cba34c9ea2d05cdb55954750b0f46a5a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b00f84543f91ed05c4e2d6b88fe2fdebba7f512a47735b184530ba967d8b9921"
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