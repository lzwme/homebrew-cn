class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.14.2.tgz"
  sha256 "126e778777e08ec31913a53be07d25026d986139df0ead0ed775b6d74bf60b3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ecd220e872ec2e1d2247888da861dcf09b08be4f700c0f9d0d42622db912ff7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d87d465f708dba9dc2055c65ee1f62e48c63fdc0fc7f45cc96ec0ed9ae4d4f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7102ff690a35046e8e4d47d38bd8ba602ad89c605d06ca6176d7ab9fe8d45711"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eb572eff5541a165804e4b57699e5189b107f0c78105f8f55f42282c4bfddeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3addfc0375f2acf4612cc3cb4c895269b9bd208498611f2aa66a050ee3f356dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3addfc0375f2acf4612cc3cb4c895269b9bd208498611f2aa66a050ee3f356dd"
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