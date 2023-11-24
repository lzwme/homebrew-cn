class Mdv < Formula
  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc43a81dcd0224e032355f7ea81dd6de635ddd47b0b825976b89c279fde6ffb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbe4c48d4bc66d2320979367b7278755f56be8d5eac7e2f3b35d5d3d520f3a63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb5dc631d29d93f8b0f129397af31130c191a999817c313d0ebd346e3918b602"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb4ebfb14b2f20cc6da9c45ba8c34150b5d827b49c1d8201802d77a472464908"
    sha256 cellar: :any_skip_relocation, ventura:        "a57584e6b7b87bcbcabd58e7940d12ccf5190bdb02aa3603d76768106fe93180"
    sha256 cellar: :any_skip_relocation, monterey:       "0c089e77f856a538eee4a3b282eb30906ed2590825a8c03655994ea500d7e07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b962c0ce56c2662067b53e2b40b8499b4cda28011790acbd4fb18a17576030"
  end

  depends_on "python-setuptools" => :build
  depends_on "pygments"
  depends_on "python-markdown"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.md").write <<~EOS
      # Header 1
      ## Header 2
      ### Header 3
    EOS
    system "#{bin}/mdv", "#{testpath}/test.md"
  end
end