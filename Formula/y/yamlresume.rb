class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.15.1.tgz"
  sha256 "5d786cfe50624f4bfd2974a1be26be823a2a759b5fef00f7e0b277c5feb23083"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b8b02fc06b2dac756c2a5a5ea9ddf93a5d7eec321d1b1317d6c60568a7ee52d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9bfcc86b227c7786d37db77a902be44e52619bcc82e03795f357d7721026838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "700ef3d41ebc3a7405ca9a3a4356f880a93bf3559be5a5d3e66b0cacc1db0a85"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fae64b795a9b6a194ef64deb2ba2639f56d16f91484d6f56eaf22330713d1c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e62d950c03d2516e5797b8498d796ad82f137df296fe72ce7fa68337d001444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e62d950c03d2516e5797b8498d796ad82f137df296fe72ce7fa68337d001444"
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