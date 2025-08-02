class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.4.5.tgz"
  sha256 "7b833899ca60a142b338c73a9cc3d216dd0690ffad68ff31c951a3de8269cd56"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "406bbade2f2aa698d1c73481c71488b326403cbbb928f23eef126d380b506f36"
    sha256 cellar: :any,                 arm64_sonoma:  "406bbade2f2aa698d1c73481c71488b326403cbbb928f23eef126d380b506f36"
    sha256 cellar: :any,                 arm64_ventura: "406bbade2f2aa698d1c73481c71488b326403cbbb928f23eef126d380b506f36"
    sha256 cellar: :any,                 sonoma:        "0f3df6244e338bed2cdb76c34e7d07ef05d2c83e90c106f4d79a85b9120aab10"
    sha256 cellar: :any,                 ventura:       "0f3df6244e338bed2cdb76c34e7d07ef05d2c83e90c106f4d79a85b9120aab10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8e958a0bc6fe5e9e409c2d6ab4bebff9209b8df1eac058e8219eb22147eef62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58dd64948c9b48d1c551f41f502e23272ed9f067e49ee7274942d0f62faef80e"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    term_size_vendor_dir = libexec/"lib/node_modules/jsrepo/node_modules/term-size/vendor"
    rm_r(term_size_vendor_dir) # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end