class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://ghfast.top/https://github.com/Scalingo/cli/archive/refs/tags/1.41.0.tar.gz"
  sha256 "3d70160ae39d74b13048a9610627d39173c7e62479bed84e1f265511bc8d053f"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b3c58b8159bdd5de29f3378d8a622218f87a203fc98c6e217badad3dab7350a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b3c58b8159bdd5de29f3378d8a622218f87a203fc98c6e217badad3dab7350a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b3c58b8159bdd5de29f3378d8a622218f87a203fc98c6e217badad3dab7350a"
    sha256 cellar: :any_skip_relocation, sonoma:        "34ea8d5ee84476ec19ce8735914fda02163c47a723cf487e9bb63818de24603f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1495788e6c21650dd841a2bf707f6566439bb7c610464ca4ad9b22a45dcf10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e7252be3451f98d433aa8a0c7a8f353d0c2c4632566fcc96c1d819f7e73fe27"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      ┌───────────────────┬───────┐
      │ CONFIGURATION KEY │ VALUE │
      ├───────────────────┼───────┤
      │ region            │       │
      └───────────────────┴───────┘
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end