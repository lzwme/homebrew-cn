require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.7.1.tgz"
  sha256 "a5dc54d7e4cc36c8fa68ab6312a24cfd1ad44decb2280e840e54b95cee96ea42"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "104c608135d183affc07d0231be5f52660c94786a6fa9215ce0060bea45ec3be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "104c608135d183affc07d0231be5f52660c94786a6fa9215ce0060bea45ec3be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "104c608135d183affc07d0231be5f52660c94786a6fa9215ce0060bea45ec3be"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c97a3da1e0aaf22fdc4dff2a444a7964e11ca59261f6ae9b11bf903e2078069"
    sha256 cellar: :any_skip_relocation, ventura:        "5c97a3da1e0aaf22fdc4dff2a444a7964e11ca59261f6ae9b11bf903e2078069"
    sha256 cellar: :any_skip_relocation, monterey:       "5c97a3da1e0aaf22fdc4dff2a444a7964e11ca59261f6ae9b11bf903e2078069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "104c608135d183affc07d0231be5f52660c94786a6fa9215ce0060bea45ec3be"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://docs.stepci.com/legal/privacy.html
    ENV["STEPCI_DISABLE_ANALYTICS"] = "1"

    (testpath/"workflow.yml").write <<~EOS
      version: "1.1"
      name: Status Check
      env:
        host: example.com
      tests:
        example:
          steps:
            - name: GET request
              http:
                url: https://${{env.host}}
                method: GET
                check:
                  status: /^20/
    EOS

    expected = <<~EOS
      Tests: 0 failed, 1 passed, 1 total
      Steps: 0 failed, 0 skipped, 1 passed, 1 total
    EOS
    assert_match expected, shell_output("#{bin}/stepci run workflow.yml")

    assert_match version.to_s, shell_output("#{bin}/stepci --version")
  end
end