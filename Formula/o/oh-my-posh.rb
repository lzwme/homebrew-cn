class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.22.1.tar.gz"
  sha256 "45e9c4c2b543e6fecae7ed45159d2b26e720cc7484feb8ac7ae7bb41ae52c429"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98c4e52fea2e1aa8cbd766bfdd3ca3b2bda7351c58131811592160ee4271d8a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b72cbafedf219a86f82ffc6524804b0c409cf0b44edfd70a617a1b6ca335f4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15bbd5ffd868aa504e48240c1149a49d0bb6bc4a216b7338bf04c9302bc39458"
    sha256 cellar: :any_skip_relocation, sonoma:        "0853b34253924df8377a482f858e17880e70f1b7cecd8d5bb39a3c9aeb7192aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c32c5b8ba641998fdc83a7c7fc19f2ae3a8680b3e797574f3c32d22d27a0b399"
    sha256 cellar: :any,                 x86_64_linux:  "f426e76f74435d6d2b9c0b38e035e3b881119cf56622f85d43d3037e4f7dd7fd"
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