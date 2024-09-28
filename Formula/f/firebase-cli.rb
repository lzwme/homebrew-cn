class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.20.1.tgz"
  sha256 "d74ee75bf4b1eebf4b4231a8f25ed806da32a9aabe3873c85fb8a0027615bb9e"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27917f46f8a7261c72862cdef9fa4653c1c42f5e725cf81f8e3ff86d9a475bdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27917f46f8a7261c72862cdef9fa4653c1c42f5e725cf81f8e3ff86d9a475bdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27917f46f8a7261c72862cdef9fa4653c1c42f5e725cf81f8e3ff86d9a475bdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f86ca629d715ae49d3d24f43f0f2aaf5f066cad475d92a4d8e107792b01dc478"
    sha256 cellar: :any_skip_relocation, ventura:       "f86ca629d715ae49d3d24f43f0f2aaf5f066cad475d92a4d8e107792b01dc478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eed5fd80372fda3a1982e05cdfacfac0eeff9cc7a62d16d405148c7124053a9"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"test.exp").write <<~EOS
      spawn #{bin}firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end