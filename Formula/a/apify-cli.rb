class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.9.0.tgz"
  sha256 "dc737fc37a9d34bf0db399ed874cd8b8299d15fe36fb74c81e1bea3013c79045"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "250a7fc65ee706991d6ad944de3afe6df58750043811c69ab70650d85398aa07"
    sha256 cellar: :any, arm64_sequoia: "250a7fc65ee706991d6ad944de3afe6df58750043811c69ab70650d85398aa07"
    sha256 cellar: :any, arm64_sonoma:  "250a7fc65ee706991d6ad944de3afe6df58750043811c69ab70650d85398aa07"
    sha256 cellar: :any, arm64_linux:   "7abc4f3d9d5f7bc13e2a4401c71632c67dbb4a9bdb819d98e13b7afb87bb4304"
    sha256 cellar: :any, x86_64_linux:  "5628552e88dcdda056364fc441e28cb98d80203460ef800ef13d321e258df474"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/apify-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end