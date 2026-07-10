class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.16.tar.gz"
  sha256 "92858e08217786630e235e15f5906a49ec6b260e9a02f4c7c8559e35bde4079f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b74a37cfd28feb1669a4a84e916d579e7d8bcb181dfcd47e4bdf52e381a942a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f98aed44b53c9c450e0fd50db53532d5829bfcba12eaabc80e81c1c0719635b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0227d6dae586e87c4fba17f30444d35202f8be2a68efd8ca40a6c0b7cfd29fa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "795a75d5dd578fbf4085b1fc4ce9b17594343994bd1f67adab348c834c754e60"
    sha256 cellar: :any,                 arm64_linux:   "dc4db302567c50d9304ffdcd60ed7513bdc9d2b26f420fe84c03c77bd8d77733"
    sha256 cellar: :any,                 x86_64_linux:  "41ca7f7d2746a77121ff5a9adf86e1e859cb17275a7cced7fdb30983b4235841"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end