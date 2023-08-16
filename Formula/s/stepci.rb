require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.6.7.tgz"
  sha256 "5893aa043c2e9863ff485a7e0057f681d797663b58ffa0ed23edf2e68fe11727"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39dc8464a74626fd74489583d71363883d1d4752af475eb04b2ba2e12bc45492"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39dc8464a74626fd74489583d71363883d1d4752af475eb04b2ba2e12bc45492"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39dc8464a74626fd74489583d71363883d1d4752af475eb04b2ba2e12bc45492"
    sha256 cellar: :any_skip_relocation, ventura:        "c4a78879147a4285686102ab35f055c97a3bdab7e198a0659f58bfd8d4a26d96"
    sha256 cellar: :any_skip_relocation, monterey:       "c4a78879147a4285686102ab35f055c97a3bdab7e198a0659f58bfd8d4a26d96"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4a78879147a4285686102ab35f055c97a3bdab7e198a0659f58bfd8d4a26d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39dc8464a74626fd74489583d71363883d1d4752af475eb04b2ba2e12bc45492"
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