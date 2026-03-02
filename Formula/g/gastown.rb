class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://ghfast.top/https://github.com/steveyegge/gastown/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "7e542737f784ac1247cb62eb828bc4267c5d5cab547696253623d4a717c57d3e"
  license "MIT"
  revision 1
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5234b977e341d7f90d668509f5d1194b95e4972d025340940364fea04ed42c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5234b977e341d7f90d668509f5d1194b95e4972d025340940364fea04ed42c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5234b977e341d7f90d668509f5d1194b95e4972d025340940364fea04ed42c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc640957b0f0bb8431f6cafb9ae586209c0f2758e15d7384964f5b685a12f7f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "083919b9e67d0785182e2bd95d6fdbd534a1aa2b67b7a115e53feeb18124bd5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e1f0e26a356d28094951bb613131fe3cc6260bc6c452eac0691c8232bfbfcac"
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