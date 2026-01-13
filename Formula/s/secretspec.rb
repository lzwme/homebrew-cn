class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "cd3c6e5bda1056d1738f34c723d8d087a0a1f931ba328a4df6d14febe56e7020"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8ea7e0ed3ca7a2a326336354e3a2329a9ff5654e28afe789a56f00f214cb8c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "852337aca7b8f711079ceff02482a5fc7e5d9dafd174e8ee190b674f9fdaeb3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "216438fc94376554e2066caaed0b83ec933bc11533c0b72fdbbb53ccc4f47fea"
    sha256 cellar: :any_skip_relocation, sonoma:        "84ba4500ca03ca59ad0a07e9c4a7c89547fd064df57d8ba50814fa10874e31e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3af75fc1b2e4cc354cfa0ba884e66383747ce0946d324f8924ac4eeb5b93df3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20d9b1947052fc0e07a88cf942b0773d1bd6c4fecec510739a99a9c0e115b916"
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