class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.5.4.tar.gz"
  sha256 "562203b8d79585214a47104a37285758e38fa50def570dae685176298dc70066"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2b3883dc1737d9ca29b8950b1d7e14478dac63e1aba70b86f8a57a514dc49b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ce6a8f984062fed3f2d78f02e8af2743815299a5365e23b32dd0436af62ba92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d53991b849c2cb2ecfaf6570b3ee9c28d9bf51cce43799bec031f120e81cfd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d18d9c9f151e2377eb84d6e50a3e5ab5db286091e91daa0cdb44826158740cb4"
    sha256 cellar: :any_skip_relocation, ventura:        "4a69da525e929887006ea614813a617e9d10894643f2fe69f1db0c2faf20c28e"
    sha256 cellar: :any_skip_relocation, monterey:       "732367f8e52b8cf47085abed857a9a3086500503fd34cb6b9f25d9bf9f80b207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f501d0c5c77d00868d3839e4151b83762081bbc53c034b5be75c82a7427261b"
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

    assert_match "`os` imported but unused", shell_output("#{bin}ruff check #{testpath}test.py", 1)
  end
end