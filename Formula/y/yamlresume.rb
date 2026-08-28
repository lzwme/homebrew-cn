class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.15.3.tgz"
  sha256 "76f9adf1106c634a5f988b8f46c28fe6e27de3d7c68d396b81e159aa43526edf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b89e0977a8908763f831ee412710b19ea68ecb6d6304441ade309b33b5e2040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7e535386d68ad8266ecb540c8ae7148c43d2d1924f24cb979a3a67a2dfbcf7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cecc5c8e644049d883aebb7a9651d10b1fcd1a5a5edca9bc26bf6e294960628e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2da6e7c6f5e4f0a7de005460093ccf071357cd9c6e450f6185ac10d0a5e3b9d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2da6e7c6f5e4f0a7de005460093ccf071357cd9c6e450f6185ac10d0a5e3b9d8"
  end

  depends_on "node"

  on_linux do
    depends_on "fontconfig" # for font-list to run fc-list
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    # Replace prebuilt binary by compiling based on upstream build script:
    # https://github.com/oldj/node-font-list/blob/master/scripts/build-darwin.sh
    cd libexec/"lib/node_modules/yamlresume/node_modules/font-list/libs/darwin" do
      rm("fontlist")
      system ENV.cc, "fontlist.m", "-framework", "AppKit", "-framework", "Foundation", "-o", "fontlist"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlresume --version")

    system bin/"yamlresume", "new"
    assert_match "YAMLResume provides a builtin schema", (testpath/"resume.yml").read

    output = shell_output("#{bin}/yamlresume validate resume.yml")
    assert_match "Resume validation passed", output
  end
end