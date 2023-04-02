require "language/node"

class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-8.0.2.tgz"
  sha256 "9638dc2025f20f3fecd5e1e0767165e5fc79ff06ddff2a3f87dd3747d8e2c283"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e1e71c317cf1efb7275df2cbcfdcb8f6254576dcfec50c2ee5bc6f12ae82110"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e1e71c317cf1efb7275df2cbcfdcb8f6254576dcfec50c2ee5bc6f12ae82110"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e1e71c317cf1efb7275df2cbcfdcb8f6254576dcfec50c2ee5bc6f12ae82110"
    sha256 cellar: :any_skip_relocation, ventura:        "c7d7514927582111063eafe550f34451797e59a0cbe280a6f3bb945c0e53b3a7"
    sha256 cellar: :any_skip_relocation, monterey:       "c7d7514927582111063eafe550f34451797e59a0cbe280a6f3bb945c0e53b3a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7d7514927582111063eafe550f34451797e59a0cbe280a6f3bb945c0e53b3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a1b9f2b0c33ef97d416e94e46546ec1e68ef30951a9b14edee537d38c2013b8"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules"/name/"node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi --no-say love 2>/dev/null")
  end
end