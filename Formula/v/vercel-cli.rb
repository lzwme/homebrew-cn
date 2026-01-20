class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.6.tgz"
  sha256 "4cbb62fd9aded9f72ff7b2398619b3f92d5a83e7996135baa037dde8e7198c3b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eac6b9cfdef71910300060ec01b75b58ee3c39541228e548ad30227d76d42551"
    sha256 cellar: :any,                 arm64_sequoia: "4e4f07908799393d9b6c997208687674c689e7c896923657cacfd5e079c027cb"
    sha256 cellar: :any,                 arm64_sonoma:  "4e4f07908799393d9b6c997208687674c689e7c896923657cacfd5e079c027cb"
    sha256 cellar: :any,                 sonoma:        "efdbe6af84e36c512fe3ff46609cf744f2434617d467cfe0f8bffe8d0cac99af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa9a90a828fe12f52dd13635a94d8f5a8980fb767bfad4163a23cfeb2f665f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c91b8b666e379d8d73ef8a8abe4c3d6d44e4107afe7b239d2200a0f91e2e469"
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