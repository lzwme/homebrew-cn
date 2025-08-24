class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.4.0.tgz"
  sha256 "335f26b60ed03b51bfd00cf3de098a7b7395c6f2d104efe142f5d946d1d4dfa5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "827bf1ed800eeba968140e8ed544052ff5a7b133faa99cec8ae2ddc2184ac623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "827bf1ed800eeba968140e8ed544052ff5a7b133faa99cec8ae2ddc2184ac623"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "827bf1ed800eeba968140e8ed544052ff5a7b133faa99cec8ae2ddc2184ac623"
    sha256 cellar: :any_skip_relocation, sonoma:        "827bf1ed800eeba968140e8ed544052ff5a7b133faa99cec8ae2ddc2184ac623"
    sha256 cellar: :any_skip_relocation, ventura:       "827bf1ed800eeba968140e8ed544052ff5a7b133faa99cec8ae2ddc2184ac623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cda06bd1d5696fb69bafba37c859398a261a14646db99f84a255cae71746e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cda06bd1d5696fb69bafba37c859398a261a14646db99f84a255cae71746e51"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repomix --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repomix --style plain --compress #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end