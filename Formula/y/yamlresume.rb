class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.16.1.tgz"
  sha256 "897ddad7dd25814f24c8c12d5e04248dac62a3bb9d6a5b49c9873f4a9b861624"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f146349761bc319da912ecca0cef7a29fe97e3aac219b7a41ea2beb64aedb26"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "284aa333b474069c22fb712ff61eeba8615513d58c7a332b59be55a02d368b78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "749c0bb91b6128bc35bff56353af20653b84249c40f8da0c029473ce73aebe3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2a8765885b8e0878d7f74293148f97d9ed095286308edc5375223a159e659ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2a8765885b8e0878d7f74293148f97d9ed095286308edc5375223a159e659ac6"
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