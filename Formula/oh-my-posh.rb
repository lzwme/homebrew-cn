class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.7.0.tar.gz"
  sha256 "357f695c04e075c08546570f067328faa9d66f0686e67eeaa51cebef45ead198"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f8ebc62357a4690fbd23f0290dc3731d5cb7b735b9cc29d3ac4a3831a9bb4b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4e26ae609ad25f7b78dcd83a116a9dfc593ec7ec33d4bda14cd22bb86dfdba1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a36f5739594d8ae265d82e88f2e63b14c9997c81fad42fcbcefd7848f814d5d4"
    sha256 cellar: :any_skip_relocation, ventura:        "6fcdb28ad88b0c2d7d261ac25ba09b87d1da25f3f10161a3c7f9958ed4de0776"
    sha256 cellar: :any_skip_relocation, monterey:       "943da6b24e57c09fcb5a2ca5ce9dcfc650e383ca387e85ef15ccfa1064657f28"
    sha256 cellar: :any_skip_relocation, big_sur:        "beb93159245eba89289ffd17255439b74074e90aa3ef70043d742f771afc627a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4447dcc9ab054819fc8c59492ef411a840e636791ad6400917289a0d6a7cec0f"
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