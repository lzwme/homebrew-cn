class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.5.0.tgz"
  sha256 "69d9d32937ab4f87f001ca7e39e8c544b76c409c36be7fbcc40cb228cc1ee334"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "92ad8e3d0c3e4650aa48c90fe7420f6ccece7f9c69fba5ff42cd2020ecd3da61"
    sha256 cellar: :any,                 arm64_sonoma:  "92ad8e3d0c3e4650aa48c90fe7420f6ccece7f9c69fba5ff42cd2020ecd3da61"
    sha256 cellar: :any,                 arm64_ventura: "92ad8e3d0c3e4650aa48c90fe7420f6ccece7f9c69fba5ff42cd2020ecd3da61"
    sha256 cellar: :any,                 sonoma:        "bd571d68e6805083041fb7300b7a7921ccd660f6df794c73227d5268b2b75e39"
    sha256 cellar: :any,                 ventura:       "bd571d68e6805083041fb7300b7a7921ccd660f6df794c73227d5268b2b75e39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "875ed275fe46e77a8327e5f4fada5eed52a3b090008c82b420154decc74511e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48610b78cfdf018525c311873945589c279c209091941dd005a9951c812998a7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end