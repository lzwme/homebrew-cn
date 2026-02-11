class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://ghfast.top/https://github.com/Scalingo/cli/archive/refs/tags/1.43.1.tar.gz"
  sha256 "7b06b45ded3c3b16076955fc06efebcd418b7d82bc59aee9abc5e6587e684f2a"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fb4a52e2d8dcb260847f551f79202eb4b59a7581997a18c2731bb44e54705a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb4a52e2d8dcb260847f551f79202eb4b59a7581997a18c2731bb44e54705a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb4a52e2d8dcb260847f551f79202eb4b59a7581997a18c2731bb44e54705a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "070490520d67ba213e8d0e6ed57e54f420e075eba61e808f2178a1bafa6c0d39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "599e44d66d2629aca98425cbd49f1fbdd0521695e83d9d4fadf26324f9e47f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d4f0251f1893cb6c636d53ed206b1851f3d338935402015110be85959768c68"
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