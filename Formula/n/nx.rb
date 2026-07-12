class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-23.0.2.tgz"
  sha256 "888dd09f040e369aae3769e98e396bff7978d1e09b46293dbb411a9ecec3e4d1"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca70f383a53a40518300ca0238b83bf0cd80df9f5a64a6431cf5d6984478e8da"
    sha256 cellar: :any,                 arm64_sequoia: "2eb9e217e6a0878510abeec0f8ae7f0c7af2eef442bbad863055e1549d7774c2"
    sha256 cellar: :any,                 arm64_sonoma:  "2eb9e217e6a0878510abeec0f8ae7f0c7af2eef442bbad863055e1549d7774c2"
    sha256 cellar: :any,                 sonoma:        "cebe28ba319f06f3761b193d4ab20709e970f3630b6b5f880951466ddeae55d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44cf4b2145b60c3a7c2d65b999d45463401973e55e4491e9a36fd2ec38b9ae45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34aeef2628216f28c49d48e79606357117423abe776ab53c1526150d50c60189"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx test").gsub(/\e\[[0-9;]*m/, "")
    assert_match "Successfully ran target test for project @acme/repo", output
  end
end