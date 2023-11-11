require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.7.2.tgz"
  sha256 "50c56c48ecb4c1eda0c025595edc752dbc1a4740f86c5ba0c5ce44159292503a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d55731b3895a6a84aed59005ef641424e5d15b29b660e326d166f106a0c192d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d55731b3895a6a84aed59005ef641424e5d15b29b660e326d166f106a0c192d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d55731b3895a6a84aed59005ef641424e5d15b29b660e326d166f106a0c192d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7e128f36f9a9ae64284168d73368afaa905568d13a712c55bcce97a7b014550"
    sha256 cellar: :any_skip_relocation, ventura:        "c7e128f36f9a9ae64284168d73368afaa905568d13a712c55bcce97a7b014550"
    sha256 cellar: :any_skip_relocation, monterey:       "c7e128f36f9a9ae64284168d73368afaa905568d13a712c55bcce97a7b014550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d55731b3895a6a84aed59005ef641424e5d15b29b660e326d166f106a0c192d1"
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