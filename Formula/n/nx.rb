class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.2.3.tgz"
  sha256 "8aedff794de149331371d63940d010a5241c209fffd3c413074f390177e68c49"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "35b6b7c3b481770d90f208d906237933ffdcdefb4f009af6debe300228f15de2"
    sha256 cellar: :any,                 arm64_sequoia: "3498c67a3e61506d95bdb7d164dfd895c2b07dcae51056f9a1d121a1c8301f51"
    sha256 cellar: :any,                 arm64_sonoma:  "3498c67a3e61506d95bdb7d164dfd895c2b07dcae51056f9a1d121a1c8301f51"
    sha256 cellar: :any,                 sonoma:        "7f3925e8af9709b818043ec3fe6f395108c00db1f7901c5cb94ce98cec09b890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b26ce96dc2a223e7a1eb2bfad3116b1f59add25c54824a57cb08e7b0d3193adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67b1cae8e3b7d9790f3187edcfc9e6871b480c6623461e68d978d424106a9b29"
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