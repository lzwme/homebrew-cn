class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.1.3.tgz"
  sha256 "444b246230ffb654120e562a8d133ca6184fc51a835a2a7eb8b7dc13ed7f3fed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fbebd40a379525af358d99d3efd416f79527d70b0604500b63aa868a67049215"
    sha256 cellar: :any,                 arm64_sequoia: "fbebd40a379525af358d99d3efd416f79527d70b0604500b63aa868a67049215"
    sha256 cellar: :any,                 arm64_sonoma:  "fbebd40a379525af358d99d3efd416f79527d70b0604500b63aa868a67049215"
    sha256 cellar: :any,                 sonoma:        "f150b73a6af16e2aede579234441de8ff07e04a12bd03bcf1036cb3570566572"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53681acae1735307d46de62b597760eea7a945269b259de5b4cf2d4eac6659b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e34d2bfa1e6faf3628a13ef480a582914d461bb2cd256d171447c0aa3c80bfe"
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