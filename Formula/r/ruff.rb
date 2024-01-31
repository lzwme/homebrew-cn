class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.1.15.tar.gz"
  sha256 "cd33ec2021e5f9d931939b1915bf19e1f2ecff95c0cf845e08acea1bc953c6b2"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69d11f6f42f811620ad209b0c36c6ebded58d3a271196a514f850823f9b0a10a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8ddbdedbb74024092482772000546069b7e6eb0fb45566e2b6321038846bb2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df5e64f00dba9e9a6038149774540ed9ebfbdc6e4f8f094edbc0707a74bb2012"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e1d95cc5cfaf79eb858a0ff050412c75d03efc3fe6bb5645050560da21aa410"
    sha256 cellar: :any_skip_relocation, ventura:        "e9f99179348bcffdf057b6b3daf1475a4555476880e45eaac941a1fd124f8ed1"
    sha256 cellar: :any_skip_relocation, monterey:       "0fe21375f7d4bb7b05f6e77af77058d7ab7cb866b8a5684ab7094d62d5194f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc3c97cd097cd4e459ced3e4e00c27ed7eca50ccfebf616ba93336fe7d4713e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesruff")
    generate_completions_from_executable(bin"ruff", "generate-shell-completion")
  end

  test do
    (testpath"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}ruff --quiet #{testpath}test.py", 1)
  end
end