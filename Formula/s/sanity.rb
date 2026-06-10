class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.1.0.tgz"
  sha256 "037c7a0a97076feaaa7e01b0945edb8a99a306f769fb23113c694d6bf97f4984"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "da1ba95056c1236a82ed1bf74e5063ef713564f5405ac28ce7a76d38d8b9d4c3"
    sha256 cellar: :any, arm64_sequoia: "49d9e35b3297853f4f992c36132be62fd292a53eda72bd1ce24d187c181c55a1"
    sha256 cellar: :any, arm64_sonoma:  "49d9e35b3297853f4f992c36132be62fd292a53eda72bd1ce24d187c181c55a1"
    sha256 cellar: :any, sonoma:        "a46c82148130a29390740471b4042d5f39c920e6ae94d8c1320a4ed4923f0796"
    sha256 cellar: :any, arm64_linux:   "f79f690b281a74cf8b10418b573522871bbfb80d3c971c203057b9564abb49af"
    sha256 cellar: :any, x86_64_linux:  "45f115de604852392668bb3bd0940528e55d54ab5e22c16823865506296f38d6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["HOME"] = testpath
    ENV["CI"] = "1"
    ENV.delete "SANITY_AUTH_TOKEN"

    output = shell_output("#{bin}/sanity debug")
    assert_match "Not logged in", output
    assert_match "No project found", output
  end
end