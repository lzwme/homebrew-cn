class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://ghfast.top/https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.54.1.tar.gz"
  sha256 "118e2cc06ba80708418c07256b9d753501e942e28567dfdd9d10b00936153f2a"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "318b0dee947b8a4e309f2b53ba810c3f4971408f401cc9acb5916540921f8c21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "318b0dee947b8a4e309f2b53ba810c3f4971408f401cc9acb5916540921f8c21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "318b0dee947b8a4e309f2b53ba810c3f4971408f401cc9acb5916540921f8c21"
    sha256 cellar: :any_skip_relocation, sonoma:        "74c8c15309e1d494abe3b0ee5272a42637f58f16ab755ffa51c54a18e6bfad29"
    sha256 cellar: :any_skip_relocation, ventura:       "74c8c15309e1d494abe3b0ee5272a42637f58f16ab755ffa51c54a18e6bfad29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c78d04e27054030d549b30ad38ab1e277077cef8f5d7a70144c7dd0a578852b4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end