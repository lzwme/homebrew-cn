class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.9.5.tgz"
  sha256 "e197ffc4574147ad2c4ec3b154afad70c597096f8037bea74d3e2c2b5710dbc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "867578b9191c8c60b31d8128b2e029144f6366c7281db2e592b3698724def5c3"
    sha256 cellar: :any,                 arm64_sequoia: "18fce67189b4c42a1bde0e4e0f1febe4c4d3add95571223e602a143759418334"
    sha256 cellar: :any,                 arm64_sonoma:  "18fce67189b4c42a1bde0e4e0f1febe4c4d3add95571223e602a143759418334"
    sha256 cellar: :any,                 sonoma:        "0a3966fe4b0f75c4973a3c8e892e06a5f4a9dab4bccf22b7089c5f3ff50eec54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc586a6871f1e8e3e21b879d085ee021743c8ba1e4751a5762a79e9973c48592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0438ed18dcac5581e413cab665226df1cf005e71cac0fbb826d00f495b2deff"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end