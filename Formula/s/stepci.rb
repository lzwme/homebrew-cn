require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.7.0.tgz"
  sha256 "6744878bfbe87c040d79c16b699a220d92dfa00071e31f2871c6b81181408947"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24273072e086448fbb62ac1e9366bbd22260cb20aca91a5f93cd17506cd80f21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24273072e086448fbb62ac1e9366bbd22260cb20aca91a5f93cd17506cd80f21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24273072e086448fbb62ac1e9366bbd22260cb20aca91a5f93cd17506cd80f21"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7eb42ea7d831e3f34c51155e6ab9ee157094f12b172c4573e33daca436cbbca"
    sha256 cellar: :any_skip_relocation, ventura:        "c7eb42ea7d831e3f34c51155e6ab9ee157094f12b172c4573e33daca436cbbca"
    sha256 cellar: :any_skip_relocation, monterey:       "c7eb42ea7d831e3f34c51155e6ab9ee157094f12b172c4573e33daca436cbbca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24273072e086448fbb62ac1e9366bbd22260cb20aca91a5f93cd17506cd80f21"
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