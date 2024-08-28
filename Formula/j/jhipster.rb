class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.7.0.tgz"
  sha256 "cd4ed3bc7a9879d3a15a95ce1dbd631cbd1463637dac5d70c153aab920c1200a"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "8439eea81592493d45851b5f07d18aa561af48b91340465d349e5e96d9930ce4"
    sha256                               arm64_ventura:  "4dbccebb2a5799f4100932d0e43963d09c895a5bba90308512ba8900ce747795"
    sha256                               arm64_monterey: "119d4ed42bfcba5c31bdacd13742f207395d2f0e41c4de34cf2ddfc65240ce89"
    sha256                               sonoma:         "a8fb8ebf22d70754c481f51c677c6adfce24220394dc8a7a6e656b4c608e2402"
    sha256                               ventura:        "1155e955761d5493ca82e0cf2c86e7d5c0280519ae5771b4ecd5427fad8592b4"
    sha256                               monterey:       "1e5a62819a767279cead2b12cb4b1c7f7d8a6517104b6ab670fd02a75b9815d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a8787045d760e37dbd384756990e39b2a3ce2fc935bfb929e98b82c52b747a6"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *std_npm_args
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/generator-jhipster/node_modules"
    (node_modules/"nice-napi/prebuilds").each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/jhipster info 2>&1")
    assert_match "JHipster configuration not found", output
    assert_match "execution is complete", output

    assert_match version.to_s, shell_output("#{bin}/jhipster --version")
  end
end