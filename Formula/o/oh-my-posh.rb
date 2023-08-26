class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.4.0.tar.gz"
  sha256 "c61c7b4186c43780facfd04574d93b269e73263650bfef21f7f82e7cdd6bbfd9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7171c953eae33c00607afe8b44d3510db08120b08c5ded9d1bc4ef3f69f2e9d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "775858c2909aec80fe5ffb404a156f2af2d3c70a5ee3396fa7148a5a14b56787"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9ca32ac1c32e64ac9536091403fbabbd0dcebb2613856a7618ce802809a8ff2"
    sha256 cellar: :any_skip_relocation, ventura:        "ccfe8a8381a69fb8f1884ec6de21c28b914495f489fba7486e176d6fd183d151"
    sha256 cellar: :any_skip_relocation, monterey:       "e1b7e65a433a9866b5ebd584dd403604a4b2778d09dc48e8e0aaf0f338c47d2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b870b2db5eec91c97e9b282f966a267c292cdf68ab38b0a061466a9cca038656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4498025cdee458d510fa8aa2d79864ab5d66cb86ef7478fca5822146a51ce405"
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