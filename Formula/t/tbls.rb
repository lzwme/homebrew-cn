class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghfast.top/https://github.com/k1LoW/tbls/archive/refs/tags/v1.94.0.tar.gz"
  sha256 "ccdc078022d869564fc4ab4c1e1357bf3bc602b26109badeb1c7b3035c52ea62"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57f1f9a49d070d65c8de25c81a5c56583f935acee92ea046664c1847e2042cfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5863d5b4866eeb2ce454d525eaeb0eb6a3215f64c81af28104411885637809ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40bc952a1c3c9a8e007fa4803216b348621ffde8fa0b3a7a0ba72fcb0cff7c5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "753613b44de9ff6ada508adb6e5fa86e57fcba6a3330df9aa5d4ede5bcf868a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7bda7485ae69deca2287f1837e2c106f614f650d3c5ed89ed286ddf18bb52fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1550df6da826d5cb8840ea0f0a32f5b2ef1d04d99ac5cba57766b361bb9b343"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", shell_parameter_format: :cobra)
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end