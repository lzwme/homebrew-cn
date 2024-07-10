require "languagenode"

class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https:jan.aicortex"
  url "https:registry.npmjs.orgcortexso-cortexso-0.1.0.tgz"
  sha256 "ad32120974c37b1e6bb8e745edf83ccf611045b38a21bafb8cd55fe2c638aeb9"
  license "Apache-2.0"
  head "https:github.comjanhqcortex.git", branch: "dev"

  bottle do
    sha256                               arm64_sonoma:   "603541444d5e2c2c49057a3f847d5b5138f83ec14e9048743636ab598f0f0835"
    sha256                               arm64_ventura:  "016e6b942350f1712ae95152bd74178b51297b45b6ab5737f5fde0f4d6bfee75"
    sha256                               arm64_monterey: "36ae8f2a9b21aacaf97c24ddb11eba0be72fcfd1d136b04d06aa9601076c7103"
    sha256                               sonoma:         "236a3bfc8d6d5f9d04336b3ae30c2a9d0f17edc1b5e3f90c209c746972c5fda6"
    sha256                               ventura:        "57c9518227cbc44e3723f66f54d7794863310905635eb182ff02c0954b3cb8cb"
    sha256                               monterey:       "6e40acad0fed2c2e9122dfab590a62f7d689176fcd804af4181469027e3341f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "771ea24e5640bf6eba8fd81a4499acc2b2fea6db7912abbff406dd28c2943b25"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    # @cpu-instructions bundles all binaries for other platforms & architectures
    # This deletes the non-matching architecture otherwise brew audit will complain.
    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modulescortexsonode_modulescpu-instructionsprebuilds"
    node_modules.each_child do |dir|
      dir.rmtree if dir.basename.to_s != "#{os}-#{arch}"
    end
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    port = free_port
    pid = fork { exec "#{bin}cortex", "serve", "--port", port.to_s }
    sleep 10
    begin
      assert_match "OK", shell_output("curl -s localhost:#{port}v1health")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end