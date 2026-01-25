class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.7.3.tgz"
  sha256 "340c7f8c4f19b1aba96e559c266bc1ee83ce8ad98cc9048ca4024a159d252e99"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "957d654941633b158905562de604d2e6a255d77aeb392778dcf0e633e066aad4"
    sha256 cellar: :any,                 arm64_sequoia: "45a3dc6895a3b18fde86df81e66324eb1a036904351cd16cefd09b9da7a59790"
    sha256 cellar: :any,                 arm64_sonoma:  "45a3dc6895a3b18fde86df81e66324eb1a036904351cd16cefd09b9da7a59790"
    sha256 cellar: :any,                 sonoma:        "bd633ac61a0dac1e9e6ba2a0649993e0e394d89eeec0196d4d35424b6a496212"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80f26a0e73743d5947ae707b2f52d5d933a89ee63c738ef6445b5f9e94690298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d0041f98b294e57e36235fcac840d2b13633a62cb76c172140ce871b8794095"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/dtsroll/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtsroll --version")

    (testpath/"dts.d.ts").write "export type Foo = string;"

    assert_match "Entry points\n → dts.d.ts", shell_output("#{bin}/dtsroll dts.d.ts")
  end
end