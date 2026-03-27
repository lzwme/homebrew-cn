class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-2.11.0.tgz"
  sha256 "f9e32a5879e8f069a5a3d4d33cdebf90464abe164aef710341a548e5a298a0b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c513adb0320fee79e14f6d698a3998f670ab8b9501d86a4c6e8ddabc2d71c69f"
    sha256 cellar: :any,                 arm64_sequoia: "605be6163db9566247ae04cbad32390bfb8514b3b3c586d6fb1901a52f1370de"
    sha256 cellar: :any,                 arm64_sonoma:  "605be6163db9566247ae04cbad32390bfb8514b3b3c586d6fb1901a52f1370de"
    sha256 cellar: :any,                 sonoma:        "c2d5c8792329d0c616e249891c9a63a2198bc7211b054ad5cc770ca4e862b614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad1dfbdb5fc10cabd97fca3a8a328f453e8e07ca3197943dd63ab775d45b1560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41d716228ecbb6aca962d1f77717b0cd5089e980aa62e538f31bc97ea7513b50"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # https://docs.brew.sh/Acceptable-Formulae#we-dont-like-binary-formulae
    app_path = libexec / "lib/node_modules/cline/node_modules/app-path"
    deuniversalize_machos(app_path / "main") if OS.mac?
  end

  test do
    expected = "Not authenticated. Please run 'cline auth' first to configure your API credentials."
    assert_match expected, shell_output("#{bin}/cline task --json --plan 'Hello World!'", 1)
  end
end