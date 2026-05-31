class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "e5e6ffa881222e652eacf037df4b65f8f53149215fe72160069e8e983d753a1e"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf35dff5bf14e139b0b05f9d3db03f27f3604d64d55984a9a289c8b4ab1ca22d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd0cace4b3868495010bb0b98a97e1a77c4389485eec836c33d7cded91740a85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7df642aac052227eb5df53c9d1f78a0c8597c245dc50eb977758b506c5aee55b"
    sha256 cellar: :any_skip_relocation, sonoma:        "739769fe143883a0a36f790cdea539a77e110d0be33b6d82c7a4e3d6780b568a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6732a3c0a70db833e2e3885ae111246f7da0a3c7e9f061b8e03922e554e7e817"
    sha256 cellar: :any,                 x86_64_linux:  "4ef197a9ecb388d60059bf22d2333ee171de95ad7ebde723ae46eedbc55eca0c"
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