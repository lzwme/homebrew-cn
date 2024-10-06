class Sidekick < Formula
  desc "Deploy applications to your VPS"
  homepage "https:github.comMightyMoudsidekick"
  url "https:github.comMightyMoudsidekickarchiverefstagsv0.6.1.tar.gz"
  sha256 "52ae8c36eac8ea0132393b6e1507bd45ac9bc5d4a29891b8f445db8935a3b5c9"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0593beefc4f115fe06c22d7851fa889c75283e11fe7dca245c4cd1549db3e51b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0593beefc4f115fe06c22d7851fa889c75283e11fe7dca245c4cd1549db3e51b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0593beefc4f115fe06c22d7851fa889c75283e11fe7dca245c4cd1549db3e51b"
    sha256 cellar: :any_skip_relocation, sonoma:        "05ef3fdc3c730aa52ef5a4b0925e210ff7bffece7a3346e78d13143f3d0d4f1e"
    sha256 cellar: :any_skip_relocation, ventura:       "05ef3fdc3c730aa52ef5a4b0925e210ff7bffece7a3346e78d13143f3d0d4f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "889ce0b56a527908040c46a7fbef91d80783c39d65f57bc1030c3a8e05633c63"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"sidekick", "completion")
  end

  test do
    assert_match "With sidekick you can deploy any number of applications to a single VPS",
                  shell_output(bin"sidekick")
    assert_match("Sidekick config not found - Run sidekick init", shell_output("#{bin}sidekick deploy", 1))
  end
end