class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://www.asyncapi.com/tools/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-6.2.0.tgz"
  sha256 "6597de4e7f47006696fa158685a7c2c0d73422e59d267db024fdacad8771b316"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4bc4c92dd9927cddaf0b02647f6a824799aee362398fde1d247a930020e6d1ac"
    sha256 cellar: :any, arm64_tahoe:       "4bc4c92dd9927cddaf0b02647f6a824799aee362398fde1d247a930020e6d1ac"
    sha256 cellar: :any, arm64_sequoia:     "4bc4c92dd9927cddaf0b02647f6a824799aee362398fde1d247a930020e6d1ac"
    sha256 cellar: :any, arm64_linux:       "78caea61e2555f12e834011e63f499ef163dd54cba906e0e3205e4b893f7d173"
    sha256 cellar: :any, x86_64_linux:      "cc4f58f77ac0284a74c496e30b937380315ad6a163c3a9953e1d3a774fa4ff67"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    # Set the log directory to var/log/asyncapi
    inreplace "lib/utils/logger.js", /const logDir = .*;/, "const logDir = '#{var}/log/asyncapi';"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    term_size_vendor_dir = node_modules/"term-size/vendor"
    rm_r(term_size_vendor_dir) # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (formula_opt_bin("macos-term-size")/"term-size").relative_path_from(macos_dir), macos_dir
    end

    (var/"log/asyncapi").mkpath
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end