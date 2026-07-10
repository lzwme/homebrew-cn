class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.7.1.tgz"
  sha256 "ed13a60e0a75edd5a3406885fba1cffed9b3b4c5ca644bf7c6504633ea6b08e2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5e2eab7795cfc51beadc6c42580f4b0355df626472a27f09fc5e99f42a1181d3"
    sha256 cellar: :any, arm64_sequoia: "787555060e1b7ddd9891f78f38f4b185164f7d8d2f8def00b707cbb7b2a5f893"
    sha256 cellar: :any, arm64_sonoma:  "787555060e1b7ddd9891f78f38f4b185164f7d8d2f8def00b707cbb7b2a5f893"
    sha256 cellar: :any, sonoma:        "6b48b93ef086930cf0c83381f08d49b42bb7e26757edde4d9ce67b6607bdda54"
    sha256 cellar: :any, arm64_linux:   "47f3d77a19b12e38276e0c3b36c48991ab1bad0a94014c5a1c332237806317ec"
    sha256 cellar: :any, x86_64_linux:  "84d865371d5735492430ee6f10823b797fce7ce42e4eb809f51df3b20ace237d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
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