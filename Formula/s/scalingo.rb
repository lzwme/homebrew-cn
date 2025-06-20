class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https:doc.scalingo.comcli"
  url "https:github.comScalingocliarchiverefstags1.35.0.tar.gz"
  sha256 "3a7fe40b7419fac312631f8c8898437bfea0a3a14f47cc1afbba47184dd66177"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45b07f9f709820a287d40868f2cb23b3671625a4a4a6f824bb23921f346a0e90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b07f9f709820a287d40868f2cb23b3671625a4a4a6f824bb23921f346a0e90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45b07f9f709820a287d40868f2cb23b3671625a4a4a6f824bb23921f346a0e90"
    sha256 cellar: :any_skip_relocation, sonoma:        "933198e3cb45afdd6170be72c597b51dffe673e1c3f4c85336ea4bc5dfbc5ae0"
    sha256 cellar: :any_skip_relocation, ventura:       "933198e3cb45afdd6170be72c597b51dffe673e1c3f4c85336ea4bc5dfbc5ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d66ae312a3c58ef4f53ef30ee77920fd0a7a8ca1f4b200ff94c9bdfd66e51486"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingomain.go"

    bash_completion.install "cmdautocompletescriptsscalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmdautocompletescriptsscalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      ┌───────────────────┬───────┐
      │ CONFIGURATION KEY │ VALUE │
      ├───────────────────┼───────┤
      │ region            │       │
      └───────────────────┴───────┘
    END
    assert_equal expected, shell_output("#{bin}scalingo config")
  end
end