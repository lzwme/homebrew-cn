class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghproxy.com/https://github.com/coder/coder/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "eeec32fd235a6bcae49da4b1d97bf88eac7e32222b2c81c05d84d06d77632a30"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71543d6531e1b7fb5addb15004062f0957f41b85aeb6391d268d229dba4276c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b308a0175723615602479c6938a58730392dff24a3f32604d573fdabb5a99c15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e000ef6110180284b7f9e79427e4d1065fb61b58633bd8e8ca9dc6c7141d7522"
    sha256 cellar: :any_skip_relocation, sonoma:         "a937bac0720b83b7efc69b5ed8e8725fd8054f5b8f6d84af5482ff77c33c7ea9"
    sha256 cellar: :any_skip_relocation, ventura:        "2d1de15b7c0b2302732a44c5d3d45e1e81acf2645a0451751b9729da6fa8f391"
    sha256 cellar: :any_skip_relocation, monterey:       "c3e7f0a4e445d30324d1f61813a1251bd1880d123b8f105fdf9201d131a46c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeb76544f10bf447ad5b88fbd19c6d0ee5e24c5729d5fbc040ffa48e3e720886"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end