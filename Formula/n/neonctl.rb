class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.5.0.tgz"
  sha256 "710c9959469292374451006ad7007180074df2b43ded6bbd319b7f19d2b7baba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f21c9c6026a3d306160c55d299073a10265a0f52654f66b99b2995dd4a1f7175"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f21c9c6026a3d306160c55d299073a10265a0f52654f66b99b2995dd4a1f7175"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f21c9c6026a3d306160c55d299073a10265a0f52654f66b99b2995dd4a1f7175"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b75deb1a19b3a425d629308a6057e8c83798f7209e5a201e3951b148b2946a8"
    sha256 cellar: :any_skip_relocation, ventura:       "4b75deb1a19b3a425d629308a6057e8c83798f7209e5a201e3951b148b2946a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f21c9c6026a3d306160c55d299073a10265a0f52654f66b99b2995dd4a1f7175"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", base_name: cmd, shells: [:bash, :zsh])
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end