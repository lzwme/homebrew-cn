class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.8.0.tgz"
  sha256 "5f0f4dbc17baeab8123557c44d5254da2ffa5c400245fc30b8330673b476cc46"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4761be14dbac19f5c2aaa01678883a5baf2297f944e695c3f08d1c855914c8f8"
    sha256 cellar: :any, arm64_sequoia: "4761be14dbac19f5c2aaa01678883a5baf2297f944e695c3f08d1c855914c8f8"
    sha256 cellar: :any, arm64_sonoma:  "4761be14dbac19f5c2aaa01678883a5baf2297f944e695c3f08d1c855914c8f8"
    sha256 cellar: :any, sonoma:        "bb55e69ed9e00335ebcf4e1edb7b152fa9e9c517646db93d5c6abcedf20d3779"
    sha256 cellar: :any, arm64_linux:   "6417591ce3cf0eb0ddb068f2f2f2c3a8f09391997d09c5449c171c2296ed5bd8"
    sha256 cellar: :any, x86_64_linux:  "2785d45945ded7c38d6e229373050640df687d3a06b0e8f135e0d96f4c773a41"
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