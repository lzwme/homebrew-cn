class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://ghfast.top/https://github.com/steveyegge/gastown/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "9309da26f05cdea79218a0842356905132404d0c67503d578b89f304e05db617"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a349a95572e319d7496b07b397c099cb78a0cb63c26e94ef9beffd65c9fb25ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a349a95572e319d7496b07b397c099cb78a0cb63c26e94ef9beffd65c9fb25ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a349a95572e319d7496b07b397c099cb78a0cb63c26e94ef9beffd65c9fb25ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbdb7e4b216ad7e6262020ef113767b8520533646c944a8ea6181224ab48fe32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11b56f7757c49fe33a6317ebb9bee2fb541890c9933c07cba1c44b1ba6cc2c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ad668c29b0f79597362b6e5dd58ed9975951a956efc2234e178f3a8a3923e1"
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