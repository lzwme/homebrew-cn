class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.4.5.tar.gz"
  sha256 "e375f3cb436dba8e77eb8ac573e4f134fc0b57eb1e779bd02b8041358937995a"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29172a74c8729ce9d36d9aa306c84894d1237ac4441d0335dc7990167f6d5f4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bcefa803e8bd6047d0ccbc7374a390ed5b3207dd6b1377ef5e47ff84aaca72c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f68e1265d57a4810683e025cf10b37be499b5324a1b934304f0d26e969e7b281"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd59c34ab2089088d82daf9f4e7f503f91ebbc868cb1beeb77f884bb406d2001"
    sha256 cellar: :any_skip_relocation, ventura:        "3d4efd8765fc1f1256a1d7a4b98bbc9f03e9629f84a00ad8559e1a34b8a98b83"
    sha256 cellar: :any_skip_relocation, monterey:       "0ce772ac54d1e47d19804fbb88e7e105a8e71cc23acf1e47906421f7a7e1923d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8be12ba1286eef9fd1d80343c8e277df91c085a7f66e032042ac5f7250400298"
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