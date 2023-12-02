class Cidr < Formula
  desc "CLI to perform various actions on CIDR ranges"
  homepage "https://github.com/bschaatsbergen/cidr"
  url "https://ghproxy.com/https://github.com/bschaatsbergen/cidr/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "82af89049e1d5cb51ef2edec2b04d3850b3befead39792ee7191efecd65ac9df"
  license "MIT"
  head "https://github.com/bschaatsbergen/cidr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea409ff090527a492af88cbacd29f69b35057a7af11eb9d44584c39daae77e26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "903313ce38c9ccb020a21441753f7da07041326fb74b1545ab99647e2642b824"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9069d894956147f0dc1857c0ed7110bfe1e01ac30e10be4d92ca0924f2f66224"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d50e57b8a00adccbab29d2ceadf1e4a1f0becc69f82a844eea80be7c4b3ac3c"
    sha256 cellar: :any_skip_relocation, ventura:        "7149633d0c0214f9278d6914afc03510b8bff4d6bed2369b214a63d6c8b016e5"
    sha256 cellar: :any_skip_relocation, monterey:       "5038144817c054f3035e29830acfff8f4b5cbee69602cfe752049b146da32c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "426d20cc29ccd465fd5459ad0774eef353ca715a535c66ba0b469ecef9a5d414"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bschaatsbergen/cidr/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cidr --version")
    assert_equal "65534\n", shell_output("#{bin}/cidr count 10.0.0.0/16")
    assert_equal "1\n", shell_output("#{bin}/cidr count 10.0.0.0/32")
    assert_equal "false\n", shell_output("#{bin}/cidr overlaps 10.106.147.0/24 10.106.149.0/23")
  end
end