class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.9.0.tar.gz"
  sha256 "369c5a13083d0574d8593437047731291cc46f0df03142473f37d77bba075cfc"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3ee871195bf36c97eb80087f2430259ca83ac19ff24c2cf8f408053341c197e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "943511bfe4e5b4bc52e2f3160890508f04a546645edb37ce73dae77c57ee99a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e240b31d7f67defae69d7befde9e93a17c619eced4080cd014caf3127c0158cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "6725f306c8d90623d93aa5d60961486905a383ee14ff71ae46539cfd3dcce166"
    sha256 cellar: :any_skip_relocation, ventura:       "49de098952f8f910b18e755a09d86c4cfebb9b84c10fb34a55027d82a4f84fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea4bddd3c5cbac84efcbb4fc7d90a2a1ceccac8d0af1b64adf596841f37e8981"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    output = shell_output("#{bin}tv list-channels")
    assert_match "Builtin channels", output
  end
end