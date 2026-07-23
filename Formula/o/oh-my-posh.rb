class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.35.0.tar.gz"
  sha256 "7017a9ca7fb0c16ffbfddcb6a41ded1361f00ebfa1d457433e2c7bd170d61138"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e67538ac3d5e5dea4b9b3d2193fba17fad44d13ace92d8847d067aa5f5bda2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbe8b9a39eaede855cc330fa5f07d1e9278a95511927a95d7975c76b59e39b65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec79b600d0c4890ada8635fe12bdf3ed1b3c596f2670f72282d72bba61791ccb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eeb5983a7c0c0aa9956642352bf1147344c58676c703d031991b4db186e606d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edf096f801097dca0ba84114fa46ea5a212dd97f9146bcf330dff711e4adf4dd"
    sha256 cellar: :any,                 x86_64_linux:  "584da76f8e83e117400c7b7dbc357813ec1d66f6dc4fd6c2c593c293e13b9a64"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end