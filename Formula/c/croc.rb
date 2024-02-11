class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv9.6.9.tar.gz"
  sha256 "5f3aa59b938e8dd0aad1c8c00933740c6cc612f392ef19f942429bb15fbf82cf"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ada4c333c7bd89b9f09e28f778e5c1b58b7884991df634cbf5b1fe334932d23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8eb544d79200ab80d167b09d2a10f7b3c372c97314d44919f1413d5206b75df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2bf223007c0b827fc330ecc091f9ac1fccc00fbf8743086d2c4fe2b197861b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "da630b1d664b91ee1c0a7d26bd705aeff323dbba4d209797b24e29f1924eb60e"
    sha256 cellar: :any_skip_relocation, ventura:        "726a8dc3b97688fcffa86d1c8c8023191bbb99d9fd9cf1cc31e5d4b09cfca7dc"
    sha256 cellar: :any_skip_relocation, monterey:       "3b9288b0094d5b68e968fe79e335118cc501e7dae2d54973d2f5e4a45711fedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "611896e0f99f8b03f5638143a7af1dd3ee1ca0fc77cffa1703b4b131b7316d72"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port=free_port

    fork do
      exec bin"croc", "relay", "--ports=#{port}"
    end
    sleep 1

    fork do
      exec bin"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end