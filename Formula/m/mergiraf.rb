class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.12.0.tar.gz"
  sha256 "cfd698603383b12ba612d35a697404fb8ab0cfe202071ec9bae0554fd856f90b"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87d17fa2f6bffb60c31dc84ec7c69faceed1f779a861dd60249e20783b1c7839"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0d23377d7fb3004e19fa7f8ed30473354e8705f61c1a65bf8cb1d26a944c23d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0017f0b018ba65422493e217d001dddc48ecff1e5be3a27c2f78c2c161477676"
    sha256 cellar: :any_skip_relocation, sonoma:        "e88c34095e7662f4c0a5ff780e1a4a883d03eb7fb82bb2e35561ef0baff3fafe"
    sha256 cellar: :any_skip_relocation, ventura:       "ed88d34d970103f41dd8af1ba28a2d3473dd56708dcaa3a9f0700ced03f34924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a52ffb8ca10d27f18d45a0bc4bda7b5790b179a7cb76c6fc0ab0b660bc682227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc13b5c576596fba18586a1bcc84169a120955c732a71735ac79726bcc92e82a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end