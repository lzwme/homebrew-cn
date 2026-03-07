class Ni < Formula
  desc "Selects the right Node package manager based on lockfiles"
  homepage "https://github.com/antfu-collective/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-28.3.0.tgz"
  sha256 "3ce78b7ab412916686dea9775cae11555e43ceda6f85309e33d5db3ffb8b6dd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "692750812a7030148f0df54034112a0a95210a5c0db61350355c1a2605544836"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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