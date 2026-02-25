class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://ghfast.top/https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "226907d1df5a0ceabbf4ec511019cb46e4649f42642a1d1d9618a9768efb56ed"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "355ca0a1ad88f739b1fa8986f9736aa3e57902e4efd3df7fdf4e58f2f11e46bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "355ca0a1ad88f739b1fa8986f9736aa3e57902e4efd3df7fdf4e58f2f11e46bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "355ca0a1ad88f739b1fa8986f9736aa3e57902e4efd3df7fdf4e58f2f11e46bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "783ab8e35494c1015c9efca20abfd0698279a58ab2bbf8cc852eef40a7565085"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3048723fcdaf7f8baaf461edfc74ff0e58931475a1f55d9468625dd9e3eabf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d77abc2434339f1174f5ce9f814d87eded2218eb621153775c647e31ca6000c5"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end