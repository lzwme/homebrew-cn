class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.4.6.tar.gz"
  sha256 "1c32e97535e8c4c2746f2a0bb4b690699895729e98c3c9e2020dd5346b19b228"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3eed2efcd1b0f4fce92546bd8bcd572e8821ce1f783123d482d25d7a43d85c18"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "005c967d158a438763e8c92de976eea0cb28cd51e9839aace61948ab0037cc8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7cf0c2c008d55eab49a23e2f034188375e0f891bd4b608185c6b6bd90029cbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "244046da102f65e1139a25bf0cdbfb8b82c7e48b9169be51634ef8df5c5643a5"
    sha256 cellar: :any_skip_relocation, ventura:        "920708113ec68978a1d5d089a2c01155eaa6ccb1f797c9b4067cd34fdb19077c"
    sha256 cellar: :any_skip_relocation, monterey:       "cee0100085ae6b201c7878235115eb26c9ea3745f63a3568feac61aa32534989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da33e449f6450adb8522146a2f2216b14c9f7b12ed8210b584235a3cc0d1eeea"
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