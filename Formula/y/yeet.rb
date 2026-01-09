class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://ghfast.top/https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "bda599be3a1dd6ccc76f563c3a3b267b30908ce54e0a8fa40ef1717f07246090"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24aa8eeba7f96408fb67e81c727f6a9b012ae154d9812806cb34802461b5d801"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24aa8eeba7f96408fb67e81c727f6a9b012ae154d9812806cb34802461b5d801"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24aa8eeba7f96408fb67e81c727f6a9b012ae154d9812806cb34802461b5d801"
    sha256 cellar: :any_skip_relocation, sonoma:        "b48165d6fcd7c21fbdb4675ec65138dd49b09c4fff121f7910b0f4e3397c2dcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "463c63a7a97b3b97bc107a83ef7ea7e106d3ac1b15209b1825be0bb63ea7540e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79c442abb6302d8f97a4374c8947c45a003cb8aa9ad8f6ab1f4b8ee7dbc4685a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/TecharoHQ/yeet.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/yeet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yeet -version")

    output = "open yeetfile.js: no such file or directory"
    assert_match output, shell_output("#{bin}/yeet 2>&1", 1)
  end
end