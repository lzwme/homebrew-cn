class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.14.0.tgz"
  sha256 "306236025693ec8ced1633e6f98903c09fa42dc4c4c4a683cdc8befecfed1ec5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f394fbbd5ffe5ee89bb75d004581e11450d8d5f279248e471f0364853e5b10aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e302be5bd0a4da03f8c838f1be934dc922f287b722377d6420862bf170258d89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fe054e701adaf71c841bc0a9478eb32635f464362d638a0eb940b2e607f04ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d456ad277c4ae494e2904fb0d618f71dff73a9a7974be3e5249163cfbf0516a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c76300ee109ba9b8e3df9fda25128ae0828af318331ec6c88adcddf2ed1b878d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c76300ee109ba9b8e3df9fda25128ae0828af318331ec6c88adcddf2ed1b878d"
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