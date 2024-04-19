class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.4.0.tar.gz"
  sha256 "a6bc0dd542089d8ff30a76a17970b09fe508f01dcce17da3ce790e9911674435"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb28efc86064760fe85fe545391cbe8e337fac75866edc98b5dd4e81a10f5afa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bafddfbf89eaae73906801b92c7105189aab6eeb13736f26fac8eae3b5aa007"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0541db2ac1044dc9a9c23139ae06d07e3d18058edf2a09bb003aa63217e357b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e88e0fdd6ff171b3c660139268de30ead83e99c66dd2b5419816253ee731339"
    sha256 cellar: :any_skip_relocation, ventura:        "846b50706acefd208f78f9d1009d376275ca04abfbcfa7d973abd6a603477a52"
    sha256 cellar: :any_skip_relocation, monterey:       "2d7c3cf9f2af335b4624abb7527d68cb69c3af0ce85deb9611d7ed3bdf3cf10c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51255696ff4f1f52480a9682ffef1a45004d221aa70dca34e3c3defea2472e29"
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