class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "e24ea3b7fbbcc1ad640366c073126315564fbcda07164a6f1431eeb98f9ef6de"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18fe49c4ad76b14b431fcdbb1395c0d158e44800523be2ee9596568c313724f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62027186c6854435089bd770cfc3fbb9c25d21583e8dbb4c78dfd831222a2d57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d35b11e662518d3352d78d376e1ecec7c5a1cb92458d1f50a84451b3d979e42c"
    sha256 cellar: :any_skip_relocation, sonoma:        "641930565607667ae177182f687e50f6b753deab0f6bc2b9778765228d0ac854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f41a57d622ddc518b8ce4407acc5c499944d519cc74199d08e07db1e0486dc09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "463728ebbb65b7b91cb83ce7735ee46cb7b46d8345efa161224f5d6e6a093321"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end