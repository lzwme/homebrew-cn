class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.0.0.tgz"
  sha256 "bd4abfc9b71bd8e23e86a9a014da05dbf44f350699a453949321e748d45e661b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96c91a123110d537798f853e150fd5f9e271a447b408f3ee180e8a669afa0858"
    sha256 cellar: :any,                 arm64_sequoia: "96c91a123110d537798f853e150fd5f9e271a447b408f3ee180e8a669afa0858"
    sha256 cellar: :any,                 arm64_sonoma:  "96c91a123110d537798f853e150fd5f9e271a447b408f3ee180e8a669afa0858"
    sha256 cellar: :any,                 sonoma:        "689b38834d2cfb2b1b7323e1a160380c5262e5c2600a2c0b20d662785427f463"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86f64dbddc486d213f48829cbe7e8a34abb07af33c07ff85ed7578dce6f4a74c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a9ad9e1be0b509f12953cf6f54b352a24de23218b378ecb53651277869b03de"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    (node_modules/"@vercel/go/bin").glob("**/proxy-*").each do |f|
      next if OS.linux? && f.arch == Hardware::CPU.arch

      rm f
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end