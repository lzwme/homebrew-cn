class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.4.4.tar.gz"
  sha256 "8e8aaaf70d8c498e7edae181829b342c8aca0edc7eda394076d5aaa13a2f3e3e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee4afdba94fefa700a76ed2c09d005175346ac3721678ced425b56f31aa04215"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fdc0ab4b243d5da6db83e5d5f3a9846dd25ac94f81afabd33db3074f5101121"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0877a94fdf777660581f064be210070093632ebe594771ca225ff2abe6c1dc8"
    sha256 cellar: :any_skip_relocation, ventura:        "0378670cd7739cd25ca886949c202b6b8c15a19e2197fb3ef2e975f46e406a40"
    sha256 cellar: :any_skip_relocation, monterey:       "68d158b886cbfa88685b53b901bbb33463d95e97ced5bb942e63f5556c7f0f02"
    sha256 cellar: :any_skip_relocation, big_sur:        "b93908e5f9ace82a1bb90074d94ca1b3edf6eba37e41100a7e7da81c05d8509f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6b37f4127c1c1de5daf7e19571a28d45be29d818c617e070518426a11c2589b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end