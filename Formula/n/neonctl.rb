require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.32.0.tgz"
  sha256 "981ce0eaaece6417374608037ee95dca90cf1c01ea165f36b03c82e62da500bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52546eaa03c04f0f6897ff090c8d153c7c5bf5e4f1fad99a2fd9bb2b3838a15f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52546eaa03c04f0f6897ff090c8d153c7c5bf5e4f1fad99a2fd9bb2b3838a15f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52546eaa03c04f0f6897ff090c8d153c7c5bf5e4f1fad99a2fd9bb2b3838a15f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b013ad9f798e1df3b7a3c89a748f3f7bea3299f3804637a4521c9d576a7d1c5"
    sha256 cellar: :any_skip_relocation, ventura:        "0b013ad9f798e1df3b7a3c89a748f3f7bea3299f3804637a4521c9d576a7d1c5"
    sha256 cellar: :any_skip_relocation, monterey:       "0b013ad9f798e1df3b7a3c89a748f3f7bea3299f3804637a4521c9d576a7d1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e40dec13cac693f048232ef750890250d748baadf71894985a886c330f841296"
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