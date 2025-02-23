class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-8.17.5.tgz"
  sha256 "8f2eabe7948718bc5b0833fdd68e4cf304140ecbc3ec501a7a59795a2ecc5861"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6474dd6ac9362297069a3e3baaf42e53ed253f2ba5602b1f7b94783dc46e8443"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6474dd6ac9362297069a3e3baaf42e53ed253f2ba5602b1f7b94783dc46e8443"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6474dd6ac9362297069a3e3baaf42e53ed253f2ba5602b1f7b94783dc46e8443"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0feb6f04a93ca87c4a4de8bc04c1bef7cb97c6a79ce758e93d6520f3bb8d958"
    sha256 cellar: :any_skip_relocation, ventura:       "c0feb6f04a93ca87c4a4de8bc04c1bef7cb97c6a79ce758e93d6520f3bb8d958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6474dd6ac9362297069a3e3baaf42e53ed253f2ba5602b1f7b94783dc46e8443"
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