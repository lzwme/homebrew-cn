class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "594449e02da46572af43bb0876a5148dc8e479efb0ca1606fa84da7812f91716"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff682a023fa332792631f1569664fc81790f5326478867b6221728b471cc8d85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50e46ff949f0c29c811ea06c672c21eca51b8c5dd05927c827837b2738b5f5aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f60021c6c64bf603931a9c16c12aaa5465eb9812b586bc2ab6d750010388abf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce0a7d8aa9adbde87e007a8778a5458bbef1b698c2619e07889d0c9cf2c93d16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3045e53e270c594ec717d103ffaaabb4e867ed762db401c29d787b49f6fa3f74"
    sha256 cellar: :any,                 x86_64_linux:  "b68e174e4a67e24a77de1b668d400f16d68bccf355a368ed1196e387b63cc3ff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end