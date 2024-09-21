class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https:github.comafc163fanyi"
  url "https:registry.npmjs.orgfanyi-fanyi-9.0.5.tgz"
  sha256 "f81345910d2a98eabfd1d92793e085e81e70f315e0b474f47019f0a774cf5df5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "647b163411b47fcecd6c1342116888679b0a75a78ed2af252bc11efa507f39c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "647b163411b47fcecd6c1342116888679b0a75a78ed2af252bc11efa507f39c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "647b163411b47fcecd6c1342116888679b0a75a78ed2af252bc11efa507f39c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb306e52d34c98e9183e2bc2260bc5e210a1473afe4da9f4dd54f63858bbecc"
    sha256 cellar: :any_skip_relocation, ventura:       "dcb306e52d34c98e9183e2bc2260bc5e210a1473afe4da9f4dd54f63858bbecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "647b163411b47fcecd6c1342116888679b0a75a78ed2af252bc11efa507f39c3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    assert_match "爱", shell_output("#{bin}fanyi love 2>devnull")
  end
end