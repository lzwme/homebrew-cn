class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.4.0.tgz"
  sha256 "2989348c7af1134554ef6bfe901ef78fb9ac5163e989dcfc4b4b330daa4f2a98"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e17e7dc26e83365c51d381198d2faadee0b6ab49811d7610bd678d3842742992"
    sha256 cellar: :any,                 arm64_sequoia: "925517265215814c2bea2493663eca208065d545eeeccfd09943900f0e601756"
    sha256 cellar: :any,                 arm64_sonoma:  "925517265215814c2bea2493663eca208065d545eeeccfd09943900f0e601756"
    sha256 cellar: :any,                 sonoma:        "cabc5eb979da591e4a96f67c7641a984ebbb6c0a0c0243367ecf313802b0f37e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f847fb95858e7874d07b931dea11768a13c1ed992bd872394f49e4cede09d3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "278263094453586b4e2bc519cd3a981f7f3db812dfb6940da0e7fd05f54b83f4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/apify-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end