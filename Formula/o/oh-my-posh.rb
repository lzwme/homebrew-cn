class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.3.0.tar.gz"
  sha256 "d23848aed5242146d94113b641a5a32a0eccf65deaebc88329dd1fb5c8309a8c"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d50b4b4038a52bee0d4fe2195988e539d7b1505446832753b2714de48231b936"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59a5b7b8b621260642846e9fb88ec1fb96d0215043b9bf661b267df32303f5b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1772ce3ce8a61539a0fecff87abe6852de4bd12fa9a475295d027f7c5c528c2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bef620057c17cf5c3e8dce416b0ace57c6d629936df54e296dad09ad981fb28"
    sha256 cellar: :any_skip_relocation, ventura:        "b7bfe4a8f54325838fa7d2bf4373274e869ba26ec4c9ff60aa66b42298ac8cc2"
    sha256 cellar: :any_skip_relocation, monterey:       "922ab72295b595079a679f348e3ecd3b37c5c1b93440a78f4d4b4b46b3e4f2be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "709298747c0499d6b7db0a58ee47c89c5197b96709c0599dd9f0503ae351e652"
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