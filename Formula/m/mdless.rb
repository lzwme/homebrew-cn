class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.1.33.tar.gz"
  sha256 "e8f43defe78ce64cb676363905e1a9c9ea621324a9ae4ed6f23ff875849b77c8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6040b81c6fd30705b3ca2f40fac873c7d197c7855bd34800d3117dce6ed8b688"
    sha256 cellar: :any,                 arm64_ventura:  "a1ef377bbd5b27898d4a533407b52df2e08740bd3365f3ee30664efdb49b0c9d"
    sha256 cellar: :any,                 arm64_monterey: "b49e4acd814ba710bc9bd40ec4337fffcb911b1f131d8c3d927d3843ec0b8f5c"
    sha256 cellar: :any,                 sonoma:         "f207f29b161fef1530fa69c9701a141c6212842e5f5f499ed7f5b4833c1a8abb"
    sha256 cellar: :any,                 ventura:        "1aecf8e923e3d39bac1c38327c883ddbe9a1128dd5300fa8e85dc47e2c3e79d2"
    sha256 cellar: :any,                 monterey:       "4cbc8df0520702b90dcc98b796c75e1d52311c5f576702d59cc600be4bd2b4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3364051c973fb7833b755d47154f62f44264e912757a829bd4bf418b08a504e6"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}/mdless --version")
    (testpath/"test.md").write <<~EOS
      # title first level
      ## title second level
    EOS
    out = shell_output("#{bin}/mdless --no-color -P test.md")
    assert_match(/^title first level =+$/, out)
    assert_match(/^title second level -+$/, out)
  end
end