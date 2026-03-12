class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.32.2.tgz"
  sha256 "fa75bf6afba2538dd941158dc7156e2f75e02849c45560d8e81f80e1a867d34b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "64d727c8122496fed4fb432f4bc2952cf76274a06f47771c32cd8815be81bda1"
    sha256 cellar: :any,                 arm64_sequoia: "ec5bc789f2cbea4d2e5ca5acce39db4384324dd51d48fad83c52924585dcfdf3"
    sha256 cellar: :any,                 arm64_sonoma:  "ec5bc789f2cbea4d2e5ca5acce39db4384324dd51d48fad83c52924585dcfdf3"
    sha256 cellar: :any,                 sonoma:        "e7b2f13a616ae0f78463512c082008163f56651c55d8c5906514e69d8492883d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5cd2afe01f104e5668727eb9934a76c63484e7828463dce319bdba72acf3ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f9d5d3844a2e602e072f137dd8b8015df8f5d7a65756d6f320811170e8bc955"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end