class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.12.1.tar.gz"
  sha256 "841bc611e038412f0a6ec380b11c9868fcd2b47257af7c8b5043179e9e40df9a"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d218b065bad55451de291df3850b1e454a01870e11d99937d4afd657261bc565"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bffe98c9d6613ac9f44314a6f34a1418cb4ff5b2f3da83268b2fe60e7efe13b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05e7e5e778f368a5ee97888c1295d9c16372d1df68afb661470772c0fea17300"
    sha256 cellar: :any_skip_relocation, sonoma:         "0954a8c911603d3a78f29c7f9e1520d948fa127c7c225ab6ea918e83fa545ac4"
    sha256 cellar: :any_skip_relocation, ventura:        "56ddebc80c93733288ac6a017aa1ceaa4003589594de685a0ccbc6a3b4fdcf4f"
    sha256 cellar: :any_skip_relocation, monterey:       "09a854409cbdd2f9ba145b97989d107bd9fce3a6f86b3ba4385cb0bdd7cfdfed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d590ff7797a2abfd7c97d22005d7a6241903c27db699561e815902381255fa33"
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