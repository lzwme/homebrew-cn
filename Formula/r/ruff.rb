class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.4.3.tar.gz"
  sha256 "7fdff8b7391c305bad50b7982790638176785337d7369c3c8518fd384643cd5e"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d0d354190e6f8a2c8deab3e8af6e8dfff8837aad31e769e1c4d4e042467cf39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a94f1d0977f596d250f08e23cef0ea0b08d07c34fc33388f9fc603031f2c172"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2804685a0639dd4ff438cb88839c2df1000b11e5ead52bf0df25a8dfdf85600"
    sha256 cellar: :any_skip_relocation, sonoma:         "06f99b46d8751a2e816c36665ad4d42c2dd3a7f31353c6add8d41766866948b2"
    sha256 cellar: :any_skip_relocation, ventura:        "b7a946ec6a46eef2f97b1b68f1bae30cb886dd3cd0bdce73692c323d022500d0"
    sha256 cellar: :any_skip_relocation, monterey:       "27ea3304c243a14686bb02b106bb192acb1846751f7efbb773f88d3e709aa035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b64ea5bc55422811743b96af58567419e2600ba150bb0749a6f8776dc7063b"
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