class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.26.2.tar.gz"
  sha256 "2f90e562f58ec4465995ceeaab272fb7cf75dac01ca52a5f0f89320e6740904c"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c00f8131721fa9825b5e27d85a850d195c0f54286aec4a5210732ba517b05ecb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bfcf95d13a9fe1d125da100452a104494627803d3d8b5388c293c3aa7474cf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f419fb20408b918d319fd899e550f36aa528468a023fc3ad309c0482f0dc8fd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c56395ba554565cd32e26682bfeffe064e64b5293958ec02d6efeeea85867b69"
    sha256 cellar: :any_skip_relocation, ventura:        "26938f56bda5dbdd22c9864461ecd7df178910af5da91e11f45b88f4456841a4"
    sha256 cellar: :any_skip_relocation, monterey:       "fe3be3cf5efd01c9b427acefa882e9d2b5d714d20b9d69bf72a907d6e621ad36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0166a9cee1dcbc96c8bc3e81cc2f3b07da0eba59e8dfb55b0e7c6e80d8edee3"
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