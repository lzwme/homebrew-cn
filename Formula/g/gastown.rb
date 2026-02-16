class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://ghfast.top/https://github.com/steveyegge/gastown/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c785b0d76e806e3f5bf79f8d4448b21929547a61830ebe473174b163c65efb56"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67559a3b9159e317a638e293d697fee0f74e5449ad447c906c975c3f08a05eea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67559a3b9159e317a638e293d697fee0f74e5449ad447c906c975c3f08a05eea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67559a3b9159e317a638e293d697fee0f74e5449ad447c906c975c3f08a05eea"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d672216368b8e7840fcfdb73ee944116bc19c06b7cd2ac0db957cde2460b60a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ebb168b3dbc4eedfe8b047678c28205e86bae2494b44edab3c1dfd7d5910350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067c7beee4e3a90ecf35cf0473e6020071745bfc149543d1d5ab04a245865d16"
  end

  depends_on "go" => :build
  depends_on "beads"

  # update timeout for `bd version` check, upstream pr ref, https://github.com/steveyegge/gastown/pull/871
  patch do
    url "https://github.com/steveyegge/gastown/commit/991bb63dc0181d5d6356d52a6319d70ff1684786.patch?full_index=1"
    sha256 "2d584793851a1ae00e71a1fbe77512c84a33b3d0b81e5203e92cc6c11d0f3bdf"
  end

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

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end