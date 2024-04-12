class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.3.6.tar.gz"
  sha256 "5606d93fee067314c6ce5de503fcc21b2f2d40be8c8a2be6f34b49a0cacf047b"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1065c7c5c266e89cb5ef90dccb588243c03800fa815c0c097d04a5b4901aa006"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db522aadc5fcb0b791fde1d5188fb610ba9700ce970547602cd390209c2bb35d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a400f5285280897d212ce3ece43c4a9c3f7a2fde2b1ee9538b095ae362df026"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d7a633993d99b8e5d31fd100efd196310867707c42c0d4eca8c244b25e28ed9"
    sha256 cellar: :any_skip_relocation, ventura:        "1e1a981ad47d7bb05ceb1d2a51794045b414c8e7c28aa22cd444e1464084fbc0"
    sha256 cellar: :any_skip_relocation, monterey:       "e0070a52c39d7c7453b55bc04cf1f2f9e4ee0caf8380a486e33d70ada0263743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bfe7cc6b61ccfa68ba22dc8026cf312ba72159f33cddc9a38df4b3b6b2a05a7"
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