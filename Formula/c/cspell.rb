class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-8.19.1.tgz"
  sha256 "1c9f4815820a68334d88247ac4ab87f88b37063df19a2f544fc7ff851f9c698a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "359416144ce7959ee1d97cc917ba676617bd0040e09f6c9c9212e2863489b059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "359416144ce7959ee1d97cc917ba676617bd0040e09f6c9c9212e2863489b059"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "359416144ce7959ee1d97cc917ba676617bd0040e09f6c9c9212e2863489b059"
    sha256 cellar: :any_skip_relocation, sonoma:        "305334c8a4a4ae2768b09633e467caaa8560b75173e769be48f32fdb8bfbfc39"
    sha256 cellar: :any_skip_relocation, ventura:       "305334c8a4a4ae2768b09633e467caaa8560b75173e769be48f32fdb8bfbfc39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "359416144ce7959ee1d97cc917ba676617bd0040e09f6c9c9212e2863489b059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "359416144ce7959ee1d97cc917ba676617bd0040e09f6c9c9212e2863489b059"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # Skip linking cspell-esm binary, which is identical to cspell.
    bin.install_symlink libexec/"bin/cspell"
  end

  test do
    (testpath/"test.rb").write("misspell_worrd = 1")
    output = shell_output("#{bin}/cspell test.rb", 1)
    assert_match "test.rb:1:10 - Unknown word (worrd)", output
  end
end