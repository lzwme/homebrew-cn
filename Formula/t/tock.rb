class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "d2cb3853b54dcb88e026c8ebfdf263806c0a8591174448349f6c17de732e3ebd"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a09447cf2aed8252842785907ab3f870cd4f9291d96627167e943973ba670e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a09447cf2aed8252842785907ab3f870cd4f9291d96627167e943973ba670e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a09447cf2aed8252842785907ab3f870cd4f9291d96627167e943973ba670e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "972d16b559a1bc04c3c72bdd68f58c395e7ee9aa13380ff90fc8595872fa9af9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66a90d5e929cd72acebdd803e907b7b8b43b378fafbf49c5fe13fabe19c8b1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33636faa3299ca6864f976ce61418e9cdb29889425a8d5869bc03033e12ba387"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/adapters/cli.version=#{version}
      -X github.com/kriuchkov/tock/internal/adapters/cli.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/adapters/cli.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end