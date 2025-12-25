class Ni < Formula
  desc "Selects the right Node package manager based on lockfiles"
  homepage "https://github.com/antfu-collective/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-28.0.0.tgz"
  sha256 "c42870d682f7192d822f1f59660a1296ea1184e0bb0e107e44e6c564df90c458"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9bd4e213de0c31097b7384422194f7a61d8b669f912326d18955b6895fb7ab68"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    generate_completions_from_executable(bin/"nr", shell_parameter_format: "--completion-")
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