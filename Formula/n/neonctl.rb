class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.8.0.tgz"
  sha256 "a8b28ed8f6198616b7ec37cf47b99c59ebaf4e3c4037b08c6ddc09e1ed77eda1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b08e6152c0255730c09d0ee6c943e37ee3720dce7af39a4026e0c66d3deec982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b08e6152c0255730c09d0ee6c943e37ee3720dce7af39a4026e0c66d3deec982"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b08e6152c0255730c09d0ee6c943e37ee3720dce7af39a4026e0c66d3deec982"
    sha256 cellar: :any_skip_relocation, sonoma:        "e597b61722ff68d98ee91701f6e0b237437678ca720013f72e31019d753729d1"
    sha256 cellar: :any_skip_relocation, ventura:       "e597b61722ff68d98ee91701f6e0b237437678ca720013f72e31019d753729d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b08e6152c0255730c09d0ee6c943e37ee3720dce7af39a4026e0c66d3deec982"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end