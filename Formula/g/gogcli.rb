class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "584ee03fed7cfeb24d706cc0e0f0b156e6dc27aa36f69892e47be8736196c21b"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1764b6e0b56f2afa412af0ba38fc05fc74f8e08f2c1555fc394bde9913d30cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eafe80bcfea047c648201fa404db2ac86bdab818006c8ddcb422e78275e1831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c1cb6e121c5c30b7ea841d8f3e30d95c025617dc6e7edae94e34a8cc85847d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "71fc71a354774afa526736809fed7c57cb7c3b946f20350d079d8e4a0cab8464"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c70cd6bfa2c42fb0b1c8b74aab29ee243dfed7bf02423b7d979df21ce8cfb72"
    sha256 cellar: :any,                 x86_64_linux:  "a4b6213565f26cee0ae3376ff0edaa6fb8475c1c832aa2cd994bba4197ba121c"
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