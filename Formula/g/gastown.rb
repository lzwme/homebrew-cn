class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://ghfast.top/https://github.com/steveyegge/gastown/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "3be366a86e205650d02e5e8096378505374b6ae14b699c0aeb6649ef0260d661"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f283cf99928654a4fba92b606d30bd56f7aabe72e0c2e104c9dbd414b7601338"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f283cf99928654a4fba92b606d30bd56f7aabe72e0c2e104c9dbd414b7601338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f283cf99928654a4fba92b606d30bd56f7aabe72e0c2e104c9dbd414b7601338"
    sha256 cellar: :any_skip_relocation, sonoma:        "39a040137dc84d93b392bb1794652a0b191c69a9c69939dd274ebf3b910335a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2e11ce17cce4b597e1216d9f83dbc9ac06cc4038d288fc4c087f236c26be23a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29343cb4982b3ecafd4a5da3d6a2e98dc8955dda40d9cd2384ca2beb86d0055a"
  end

  depends_on "go" => :build
  depends_on "beads"
  depends_on "icu4c@78"

  conflicts_with "genometools", "libslax", because: "both install `gt` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/steveyegge/gastown/internal/cmd.Version=#{version}
      -X github.com/steveyegge/gastown/internal/cmd.Build=#{tap.user}
      -X github.com/steveyegge/gastown/internal/cmd.Commit=#{tap.user}
      -X github.com/steveyegge/gastown/internal/cmd.Branch=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gt"
    bin.install_symlink "gastown" => "gt"

    generate_completions_from_executable(bin/"gt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    system "dolt", "config", "--global", "--add", "user.name", "BrewTestBot"
    system "dolt", "config", "--global", "--add", "user.email", "BrewTestBot@test.com"

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end