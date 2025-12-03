class Ni < Formula
  desc "Selects the right Node package manager based on lockfiles"
  homepage "https://github.com/antfu-collective/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-28.0.0.tgz"
  sha256 "c42870d682f7192d822f1f59660a1296ea1184e0bb0e107e44e6c564df90c458"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4a448151946e4ba086cf681a03bb7e6eb0f8496d187b2bf9d49544c6657e26d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ni --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "fake-package",
        "version": "1.0.0",
        "description": "Fake package for testing",
        "license": "MIT"
      }
    JSON

    (testpath/"package-lock.json").write <<~JSON
      {
        "name": "fake-package",
        "version": "1.0.0",
        "lockfileVersion": 3,
        "packages": {},
        "dependencies": {}
      }
    JSON

    assert_match "up to date, audited 1 package", shell_output(bin/"ni")
  end
end