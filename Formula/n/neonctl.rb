require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.29.5.tgz"
  sha256 "f7b2301cb6a317aae409f12195b2bf7b8a2984579bbe8634b6d098e31262ffd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0423b0eeb03f0ad1e73715d109b206eb0627dae0c2c4223e60410a0cc2ae9067"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0423b0eeb03f0ad1e73715d109b206eb0627dae0c2c4223e60410a0cc2ae9067"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0423b0eeb03f0ad1e73715d109b206eb0627dae0c2c4223e60410a0cc2ae9067"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1a6b0c2b0ea6fdb53ee0941d602fd918689900a285fe3502b00052d5ceebb35"
    sha256 cellar: :any_skip_relocation, ventura:        "d1a6b0c2b0ea6fdb53ee0941d602fd918689900a285fe3502b00052d5ceebb35"
    sha256 cellar: :any_skip_relocation, monterey:       "d1a6b0c2b0ea6fdb53ee0941d602fd918689900a285fe3502b00052d5ceebb35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd6dd692e28cd22a4c6fe9d5453a29faeb43932a9e0e6de6a5244aa992544bc8"
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