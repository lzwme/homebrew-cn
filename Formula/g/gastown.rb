class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://ghfast.top/https://github.com/steveyegge/gastown/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "690ba9f7e70544ee101cda38d57fd79d1e614f4241a39b253ffdf1ea125cdc1e"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9471063074eaf3fbc95b717fe0252245fca7babe652726243537c46e874a39ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9471063074eaf3fbc95b717fe0252245fca7babe652726243537c46e874a39ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9471063074eaf3fbc95b717fe0252245fca7babe652726243537c46e874a39ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "881283dec1104b6d7b3d034e2daae80000339a1b69d8009721d7d245dc2048c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "613a2fd807746254105132365ab26500a80b577ee98f9b20cd83bae6d9a37559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2afd85f9871bd6b36ded9fd994f25adfa651fded46fbff851446d852529b2d6"
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