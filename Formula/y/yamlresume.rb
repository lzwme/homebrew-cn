class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.12.3.tgz"
  sha256 "cabc5a4b1803ef2be2187592f5db8958281ea3f109b2f8b34cac9d26be8eaa0b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d6deeb6168f978f0ab7cdfa93df2fecf4ff57dd0a42902bddf7633e2ec5171e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f96c5cd722e49715f604e24414fd67fe115ea0d516d91f691990c2641403c174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b23a38db37a4305e4e84447f138e6429e098370ea6c69177067420a48dd8af21"
    sha256 cellar: :any_skip_relocation, sonoma:        "c936822bb9fa675b905b852e3cabe33c9c58839da545b424ab5241789c0942a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c274309b382b8ce35eab32384e072679a5709c56518ccbd9c58d0a8ad8c4db91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c274309b382b8ce35eab32384e072679a5709c56518ccbd9c58d0a8ad8c4db91"
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