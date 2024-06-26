require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.6.0.tgz"
  sha256 "bf5f4013a912df79979eb5d2bd69f809a16ef147a563a9985ced0eccb9333572"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "aa061287a397511c7b144728cf25b40ad699b3f902c0ae4d376728ff59a4a4f7"
    sha256                               arm64_ventura:  "439669bd05c952c9d349272d32c847f79ea2bb7a122a8f61b7168af806ddc2f1"
    sha256                               arm64_monterey: "5c3661a6c42076669b6aa8fe66e3546d5e75b113b0ea6d6359becbbf1f740643"
    sha256                               sonoma:         "b89f493e905476db3256e13252139e2a7d4f1bfbdc1bfe68c15fae63955a87ca"
    sha256                               ventura:        "ddacb5b5f684b35f01faab78885b49d242ca8ba57f44735b7d0b4121a1cf0ed8"
    sha256                               monterey:       "e85aec9aa54c0527e186a1ac58935c6e0085df9d9605b0ed2a1c79b7eb4509b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5270776cf5eb810776e370c515c801b913d680d93c9fa40c135aa1033a1e327"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/generator-jhipster/node_modules"
    (node_modules/"nice-napi/prebuilds").each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/jhipster info 2>&1")
    assert_match "JHipster configuration not found", output
    assert_match "execution is complete", output

    assert_match version.to_s, shell_output("#{bin}/jhipster --version")
  end
end