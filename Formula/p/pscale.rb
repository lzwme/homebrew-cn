class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.311.0.tar.gz"
  sha256 "a09609dff2736d0b97dcdf6d5b71d73f5aba258328e02c013521879d21285e04"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd5a1ed7d8ba7d3ebe7a8d21286814c566319f672e1f388ab7334a77c474ce28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "409219d283e4a7081af28998cb508b5ef8540d30dcbca07362035e0dfa15682a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "584b4a56b29e9bf3eede9579f3f552ba3897274475b00771b8daa054ff9abce1"
    sha256 cellar: :any_skip_relocation, sonoma:        "035ed5bbd74b65311f69462a9109e2a6d85858f9b9d75594467a051906e5273f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0891f79d866f629190cae708820fd78857f37028b8b4c6c2673824897bd9936"
    sha256 cellar: :any,                 x86_64_linux:  "c210203e1e2aaf301182d1a342892bc560f038255c8abcc53ee9e38b350dd11d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end