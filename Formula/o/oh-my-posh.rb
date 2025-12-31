class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.8.1.tar.gz"
  sha256 "8befcff427b56f1a98b2e78204cc41135c1ac0d74281fd663dbcd90c92c7d111"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ab16b2b53c648ec38f8b23153c4987d47e87f18adce6ae016da990ce8748738"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dad80ce8e7a0ac9def34a0aed30a326a91017eeb476528ff5dcb39aa230d3ad9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c864ae27ee66746763ea620d03d6b654f57f50c5b3fc5b3b8133bf4fb5a8a4f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9895954cbba55d27cd28b52880eb6c73f486e1e82a385b456e51f676eeaf4f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bee18fca86946089012d372b9cac3751c482803ec5cc3e1e82ff1b98dfd32ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91095c2e9607dbf5df86635790cc1f05e68a184c700bb47b76ca2e6e6915176d"
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