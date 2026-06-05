class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.12.tar.gz"
  sha256 "ba14a4b75cdff2e133a1f4c076c505624f7878853e228ea0d971e04e805ad00d"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a01eb5af8bb95bb1c8693e1516b16ce810ff3436a67dd3ebfc9ec73a5b4b8b6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "833b00120e063b984c5fb9f23864409bf6e5cda223f3ac4cbdab0a210d7c3eb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b7f8ad17d937b3de7ddea8066a5ac1dc7913d807f7571bc15da30d328d16196"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cb0f65345830a8f1f10dd2da2bca006f8428d11fecd2b8371ba5f1a384d4e4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df7a2c91ce65462427b3f1fe3e1bd3bb6f3facb3f5eb5480fba8bb44dad6d601"
    sha256 cellar: :any,                 x86_64_linux:  "13e0fe2e742ffa2f6097b032613418d8217c49623b8bdead24d9c3492c2233e7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end