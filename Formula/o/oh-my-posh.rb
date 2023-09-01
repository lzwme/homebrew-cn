class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.6.1.tar.gz"
  sha256 "9334629bab9330543107c0ffba4e7a5ff82540cbca5b3b186b27fdff92d956d3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1274df54017c462cc17698ea45886daa63030c088dbdcbdd80c75932842aae1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56ef5479914f39e5c2514a08eadce45a7307497c16d250222e06ecd2ab4f148d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cffcb12e46ca0faf6a391d4f0b0b8e47b74106f107206798e654f12f67c2571d"
    sha256 cellar: :any_skip_relocation, ventura:        "9a06d39de93dec60ae81e27e97f8f86b58da48a44020a9ad90e67470e387a715"
    sha256 cellar: :any_skip_relocation, monterey:       "52b94ebc301c10fc97055093f9ba3e988cd0565c0f88594c78e0169b5111f95a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e215f26d731295f3c68ddf915d251e642d2cffe1b8aace1048d399cabdc7347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1302286e4c2088d308bfc6ec9edb5a64bbbc97ece7d41f81febe25d60f8f09d6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end