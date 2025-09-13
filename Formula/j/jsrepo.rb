class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.4.7.tgz"
  sha256 "4980d33a36c33a93f35528761aca2bfd6fadff9b4d2323736467a5ba716d0e6c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "521b2ede067dbb80308ea2d91469ea718ad703d6155ac5cbbeef65b493300082"
    sha256 cellar: :any,                 arm64_sequoia: "bd91139d3017edebf3939e09bc876a83241071d5aa3fc16fded29321ad4062d3"
    sha256 cellar: :any,                 arm64_sonoma:  "bd91139d3017edebf3939e09bc876a83241071d5aa3fc16fded29321ad4062d3"
    sha256 cellar: :any,                 arm64_ventura: "bd91139d3017edebf3939e09bc876a83241071d5aa3fc16fded29321ad4062d3"
    sha256 cellar: :any,                 sonoma:        "1e1ced5f2594e2269fa9ee87c5ce401eba63fb07039c81b70f84853e22d001dd"
    sha256 cellar: :any,                 ventura:       "1e1ced5f2594e2269fa9ee87c5ce401eba63fb07039c81b70f84853e22d001dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bfcd288907499fea9e2425e1bc316bee83aeb45eb48e0d87e6d7062fe2dc285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fc170a2fa44c1227a3fea3a62f3fc4e0095466a0b75ead81f24069efe6959d2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end