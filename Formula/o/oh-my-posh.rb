class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.4.3.tar.gz"
  sha256 "616ebae1c44add103b0727ec474cf7b7ad5621c1573dc424340868e579be3cb3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "beca1899b1e24bb211942f3beec2cefb0b109a53bb580e7dfa799ee6d6efe1ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "371159abd0bd0ec9e9dfc745198d5aa5af1e2bbb00a4175fb05822bc7f1d5fd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2459744e06a2271b32e2386316b052bf8f74454574d854beaed7a13326482c1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c823e9af3852d83cb97ce6dda9e6eaedf1134170221c83b04904905726a3f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11fc5167df362efbb2c163ce63066b9615e8c20fcd8ed220749c1ec5097caf13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd780e9891ba2b3f820d80225bd96f4e05e081043279c08e758dc46ff0dafe26"
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