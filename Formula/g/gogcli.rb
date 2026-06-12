class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "28493cfbaf6335e43db21358842f8d10ef16a9dac2da69b8697b6e4e2490ff1f"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a5535b4009255b4032dbba3823cef848fd43917fdb1ff182b364d3818b1398d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ca53bd7f01de53c37b455502c9b73ad6c4670a5f0bfd123831e855972c641bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ec788b93478b176eab5b55c1ed676b5eb40732ae390918b95393e9d4711ad4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c04945a5e025217b617138976a63c91ced4064311103201cf27e6b33e44c2e28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9602b3ad7c9f1ebdf93efd60338268288716f8b5652b8374f47ffa21666c226b"
    sha256 cellar: :any,                 x86_64_linux:  "968263cc54b6cd04eab0a8b5dc60de88900122bb337d55329873f2e75e9a9c05"
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