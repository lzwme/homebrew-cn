class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.1.8.tar.gz"
  sha256 "adbe3f5c715216a1e711cb077018641453760f8058f8ae0e81cdb88665fd2308"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66b8221fb1b38ed5eb351c443ebc3207b74e6a591f7797309042dd0477c1001b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d79797d03c4218de5d63e39300fe06aff05b314326da19c2c50e948d260be5fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "180cd4f44aaf4d2a2f73b2caaf5fab751e8ed0fbbda33e1eeb89795824e6925a"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb68c9b2d120f8ba60b9eed014c91f5a7ee72b790367635d9724b6b511171d6c"
    sha256 cellar: :any_skip_relocation, ventura:        "4e8089ffee35a552fa297ce87d3c95dff6956a1bfa66233d78e9d042a182c00c"
    sha256 cellar: :any_skip_relocation, monterey:       "a99bbf240f2536f411bf9d6bb29ed46e3c7bf1c82569ce3e4497eb77d9d9384b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56ccb0681787ec5f04493f8358301aadf2236c363d41cdebf3565e39999a9baa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesruff_cli")
    generate_completions_from_executable(bin"ruff", "generate-shell-completion")
  end

  test do
    (testpath"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}ruff --quiet #{testpath}test.py", 1)
  end
end