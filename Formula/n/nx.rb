class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.7.2.tgz"
  sha256 "6e1b20072baef61b32c31294bbc42ca528faaf169faec522fc083595a0da6220"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "597fe1b0060765f897b337c72fe504a3f46582b609a93a440382229ad1e8dc3e"
    sha256 cellar: :any,                 arm64_sequoia: "93af89e8475ed82e7db959e2d3093d4cd4f5d062fef6931c5ab3fc8cfe863885"
    sha256 cellar: :any,                 arm64_sonoma:  "93af89e8475ed82e7db959e2d3093d4cd4f5d062fef6931c5ab3fc8cfe863885"
    sha256 cellar: :any,                 sonoma:        "9ea371240c4461d356b975b3f7612d928513269d9ae351fbf52879b3e2cc3723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f5919534642e9f61f2081bc4030ba36db52c9b693033a929fafdb9896f8d6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4671007804e43ed8159d3e77a489d978470a1103267de78c3f7cd35af584d75"
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