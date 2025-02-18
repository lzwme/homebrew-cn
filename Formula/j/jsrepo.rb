class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.37.0.tgz"
  sha256 "c67e5ee17f9a1b39997d980ccaf2e6b3f00ff3bfd5c426fdba0e5e3203929e06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5e2250b164aae1c0d7068f84800f5e39dbadf2028c350913f409e772078df23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5e2250b164aae1c0d7068f84800f5e39dbadf2028c350913f409e772078df23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5e2250b164aae1c0d7068f84800f5e39dbadf2028c350913f409e772078df23"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bb05b32116247851d3aa3e9e1cbb78bd268d8c683c40ce920a32e10c469f601"
    sha256 cellar: :any_skip_relocation, ventura:       "8bb05b32116247851d3aa3e9e1cbb78bd268d8c683c40ce920a32e10c469f601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5e2250b164aae1c0d7068f84800f5e39dbadf2028c350913f409e772078df23"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/jsrepo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end