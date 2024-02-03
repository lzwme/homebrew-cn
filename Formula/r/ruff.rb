class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.2.0.tar.gz"
  sha256 "525e0e34af00725a3c71304cf87623dc2ed280a799a504849bd5ab7c8cf9c15f"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f543d7bb646f2cbb7a61f8c0cf65b946872b6d349a46809fa87c09ff0914a740"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77d8f5643dc597f918a6c56ee153c2c72cb082eb2f332e71d1ba6e964a097137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34bb326192c4771684e9110590ef6d2e74f3db6ea0749052e021afb2ca972d6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b742effd3c230b3f09f88d39ec44c9a719f320e0bb46e9f19620e410d00180e8"
    sha256 cellar: :any_skip_relocation, ventura:        "65facb579006c3af5bf1ca75a7d7e3850921663fa6923a1405973f40a9015bc5"
    sha256 cellar: :any_skip_relocation, monterey:       "e279d36b9fe5abd239737339cdeabe5c60d2348da3e04f42dc3d922d7681e88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ada4adb730683e6313b98ad9ec212f7bbf664ffc6d786e42d2e808d2c26e1f3"
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