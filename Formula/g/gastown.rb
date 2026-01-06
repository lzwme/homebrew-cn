class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://ghfast.top/https://github.com/steveyegge/gastown/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "26f13ffeb2e9d86405a3fd7ac463eed6f7e392147efcded39ce2ba2f58a6f52c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "957bf04b2367e20753c5e2ef4615cc4e47c3a7b3f3d82a895d8f7fca03dd6e85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "957bf04b2367e20753c5e2ef4615cc4e47c3a7b3f3d82a895d8f7fca03dd6e85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "957bf04b2367e20753c5e2ef4615cc4e47c3a7b3f3d82a895d8f7fca03dd6e85"
    sha256 cellar: :any_skip_relocation, sonoma:        "3877777ccffeb2b554a196139f03196fcbb5ed296ece3e145e7b29057a467b20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d790981431d0149cc96baba8b6e1760be17ee2027732bd8922eb48feef526784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2456002a0593d6db1231b4d034a3735ae7e94d3dbe7d05fdbcb87b9543ce6d4b"
  end

  depends_on "go" => :build
  depends_on "beads"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gt"
    bin.install_symlink "gastown" => "gt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end