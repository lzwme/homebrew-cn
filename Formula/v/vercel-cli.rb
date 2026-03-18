class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.33.0.tgz"
  sha256 "2dab877b2f94256e95fa3b2175d8e5ebfca762af7a0f7d48a7d0b511d3dfcadd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ebb787265ed332610fd681912c8901176734e0a24479a169d505d042f299858"
    sha256 cellar: :any,                 arm64_sequoia: "59f6f5900a298df8049fd2973698fc022cabaa24f069e567c1cce292fb733d48"
    sha256 cellar: :any,                 arm64_sonoma:  "59f6f5900a298df8049fd2973698fc022cabaa24f069e567c1cce292fb733d48"
    sha256 cellar: :any,                 sonoma:        "e5044dff75204ee8d88014dcf90786b470c0ee5ec9f1ceb62847a42b2d6e3f9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32b9073f736fac9ee3ecdbd3b60695db551fb774192c50446e99bf97ada801c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79c92c248b41ee1853226101811f67fa9d00b45cbba153cfe4ab2dc08b1db35e"
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