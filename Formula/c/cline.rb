class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-2.12.0.tgz"
  sha256 "433451d983b9b708bd7802a50a7cbdccec4be5ce55c2c05f36b01acac6ffc182"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "787fd71aaa4b1bb87177c0c2f6620447d4b0326706e19e804e480c00eefbe3bf"
    sha256 cellar: :any,                 arm64_sequoia: "03194a6552e630cc2d152ab8b270dd90555130c31bca36967b68cb7aa8043160"
    sha256 cellar: :any,                 arm64_sonoma:  "03194a6552e630cc2d152ab8b270dd90555130c31bca36967b68cb7aa8043160"
    sha256 cellar: :any,                 sonoma:        "03a65c6c67262a57182679f6059c60e3b9b6d9c794b71e99f112a18f57ed7476"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35a05b992a09fd80ae85cadfefc61c6fb76142cab8eb55765844cf2bd7f7fd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2e0b6575d5b164d3c75dbf3d5793d66f5fca0bf4d33d331c500588f96fc7701"
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