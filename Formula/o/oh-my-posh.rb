class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.10.0.tar.gz"
  sha256 "f0f5b1598d20f062ea9fa015b06c42abb9fc7b09c55402c6f757b71c8c2e4eb4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea6e0220b60aec9a1c5aa0548026df570d930bc4f5de8d9681c0460e34eb609a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4526e8ce338b27adf70b78af2a8fed1e6c45583c1bbadebdc474cb083703852f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cb5f045788336e59aca6f4a1636f855c0ba4aba8afea62e576241e54f2bcb89"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c884d1039382a4a19fb457b3ab0dd89e089d38fc1cdcfc014320b17bd7670e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad907d05682bce6c7353897270264438a4325242ec2478d6c1eba08b59722e08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de2be4f161caf6cc5864f15e924f8032f482f9b2f6909a873ddbc99daa8fd4da"
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