class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/1d/03/338fba56a6c76ea6d99ca0b7af3098292c2dd6597ed656daa6ae26a07a77/dunamai-1.19.0.tar.gz"
  sha256 "6ad99ae34f7cd290550a2ef1305d2e0292e6e6b5b1b830dfc07ceb7fd35fec09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29ec1600f234393ea6a7324cd390184e40208de3e004535724a726b8fe7ec1ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5764111fe4e0c7b3a7ca2ebac6c64717134bc3acf2f4a1121502ba95bfa11c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28c49c5cf768dea3d798b4be25476366f038c2b82325838e6b6ef737299e96f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bc870de579b120eb04040cc34b76c8c52cdc2fa4273fb34d1b58d4217e52923"
    sha256 cellar: :any_skip_relocation, ventura:        "72b0a6b4ecdf8241b85c1e96a500c6250c2748fad36bcc2dc8d692ebab9d0e98"
    sha256 cellar: :any_skip_relocation, monterey:       "e6b4e18fa7064fe54a24a5bacd1202367353bb9616d08b386dcce624bba8666f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1199b665d9ca97cfab29e557649c70ddfd120c7da54213333ffb66a0c43c8d35"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end