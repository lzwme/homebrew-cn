class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.14.2.tgz"
  sha256 "b1487005b55fbf0709d05a7d5cf256e9ef9999c8c7b30d47eb3a2c1f9bd71296"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc36156f7392b4c2706161059a2ccb196c0c76398c99e9007713d19cad096514"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc36156f7392b4c2706161059a2ccb196c0c76398c99e9007713d19cad096514"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc36156f7392b4c2706161059a2ccb196c0c76398c99e9007713d19cad096514"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7558e229b33c6eaab07ac7eeca9c32efcb5cff028069b30e9142f461012da7c"
    sha256 cellar: :any_skip_relocation, ventura:        "d7558e229b33c6eaab07ac7eeca9c32efcb5cff028069b30e9142f461012da7c"
    sha256 cellar: :any_skip_relocation, monterey:       "d7558e229b33c6eaab07ac7eeca9c32efcb5cff028069b30e9142f461012da7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e22aecee2d0718a6cef3bfa5dac277ad9da661aae70d9a482a4931d65ed62db"
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