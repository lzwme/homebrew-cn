class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.6.0.tgz"
  sha256 "c8d51b73a9208a3edf1c72c9100c867cdea8b05e7fb49bcdf92819a3e0c2b7ad"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ae495d3f2453ab58c07618d7cdfecb90da604d33048a9f389af9e27be7f4d9e"
    sha256 cellar: :any,                 arm64_sequoia: "478db2c3884eb37314ae3616473d85080e6bea6a90ee8af032a05af9a3831fbb"
    sha256 cellar: :any,                 arm64_sonoma:  "478db2c3884eb37314ae3616473d85080e6bea6a90ee8af032a05af9a3831fbb"
    sha256 cellar: :any,                 sonoma:        "32a961a0e8a8dba00d197103e5a2de2cd8b51e8bd54f5ebaeb04917a4d7091d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5826cb397c4c4c3c528079dca3e21bdf492ca2c2ac072ea8bce9ff8e725ddcd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbce1c76fedf2ff668a52326411416f04cfab5e38d30a3e0443681592612987b"
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