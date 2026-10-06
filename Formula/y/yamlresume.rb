class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.16.2.tgz"
  sha256 "2581881b1bfc811fa8fc9c15f8d35210777bea2905c20afe25c3e55d49b8c1ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6674ee535689d22bd88fdbe17712f4ea5cb42a24fa7e84336d044a8d2d1dd2d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aae8132040b679225c47b4382cf163565ae00a346162fea95dc909c36b3da34c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96e0f8fea44a2f92bb7a95756129d0ba4ec49f7ce86fd23d932ea6150b7ac550"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "67bc112dee15b36b1fd9c5775f11f566b1f112c7e6381735f0e0021452c9c686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "67bc112dee15b36b1fd9c5775f11f566b1f112c7e6381735f0e0021452c9c686"
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