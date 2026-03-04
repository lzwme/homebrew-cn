class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://ghfast.top/https://github.com/steveyegge/gastown/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "56474db2d120df51306bdc61ba4624e26c05409e4a2941ab19661508f0299038"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81f5153ffcb5c70cb5108837b98409cf72980b681a5c15ab2653df077e522fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81f5153ffcb5c70cb5108837b98409cf72980b681a5c15ab2653df077e522fbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81f5153ffcb5c70cb5108837b98409cf72980b681a5c15ab2653df077e522fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a37833ec7fe9a00e87ce57079527f0e2d4328bb083400a3e6bb767595ff21179"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "543bb8483a952dad843d48f623f35f7acb7836d461028219985467b87ed2ad19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "766c646ff0ea8d0fc4283a8717a48a3fb7d44266ad64caf97300dc3863451a6c"
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