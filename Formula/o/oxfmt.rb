class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.27.0.tgz"
  sha256 "d0f67b9bb6dd83669d9d4902483c6314385d92ca7b7bdb64e8323dae9528cab5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "540f5a875b04388b4dad74139d1141456b1bb8229dfe5d542451c6d3c9dff14b"
    sha256 cellar: :any,                 arm64_sequoia: "df340c660d49115a406dfad3136fc28cd5864a85ddabe9b4bc44e75b22612d40"
    sha256 cellar: :any,                 arm64_sonoma:  "df340c660d49115a406dfad3136fc28cd5864a85ddabe9b4bc44e75b22612d40"
    sha256 cellar: :any,                 sonoma:        "306d3be44f9d47d9cc92186aa75a509121fc206d6feaedf5841e64597c9aaa31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cbf55dbf6ec45c9068ceda5c6bd5a580c90d336e4f184facb58e6077f18c7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ec0785b71324de58286c98b473465983e72f507953070af4fb06b97a0f359e5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"oxfmt", "test.js"
    assert_equal "const arr = [1, 2];\n", (testpath/"test.js").read
  end
end