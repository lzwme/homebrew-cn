class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "4779d1a093005a7881b6e157c3d270bbb60debe715e7dfb6a53442776aa295c9"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7ac52f6b97e9e15bff95c3ebd8a0232dc8e384b4b0cef0a3f60270659e4da32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03ec3738559f9353e7d0aca3821de6b88eb76ce9933267c37de7326c0df1f84f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ddd5c6fc4d35de9d86fb5b0558a91e26756e47141b3213c843237d5552a057c"
    sha256 cellar: :any_skip_relocation, sonoma:        "997e7e50a1aca534131705184589949dbce65ce0951dd0460c592524576b2db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00b7e0647184423a71f3d1602a2d2db3ea11c0b459662ce071991582c340482a"
    sha256 cellar: :any,                 x86_64_linux:  "1d798cff8b60e6492c738efcc59c519fb15936521c7b619543f5d93f16b548ce"
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