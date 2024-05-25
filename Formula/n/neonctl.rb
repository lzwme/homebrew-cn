require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.29.4.tgz"
  sha256 "22aad38a420b72128e2dab6f1cc56fd18c2b3fa9c36c4f080c37b8501ddc0791"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3355b786101258540ef9bf67f5c06af68f32f329aada0a1ed76caa0bca6f72e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "351f26c4e5ce253be6f1e4986ee30a0c2f128c41dfa377ccd7005446f01adbbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "443be034acb1db54881789b95bbfebdcfe7b6304dd2ba9d97174f5f8a9a8b9cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb3af2ca19eeebc7510fbdb7d4bfa1e9c923517ce742cd174b1c06c8f706ee1e"
    sha256 cellar: :any_skip_relocation, ventura:        "8eb06d254cc50f8385d6d1490453cb8cb5a1ca7654fd47b898eba003544d7aa3"
    sha256 cellar: :any_skip_relocation, monterey:       "9bc86ebb4415cd50c5cae35fec9f5995bebddd2f18155f7a47e0b6419ebc4d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5489d3551d81a75d5c3eb8836043f73e26d031ebd2466dfd59c6197ae133ab79"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end