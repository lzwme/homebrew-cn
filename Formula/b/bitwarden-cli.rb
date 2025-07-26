class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://ghfast.top/https://github.com/bitwarden/clients/archive/refs/tags/cli-v2025.7.0.tar.gz"
  sha256 "a3e603683504e7e56c839b7408cacfc1a5a19cb0310f7431ec18c254224d82bc"
  license "GPL-3.0-only"
  head "https://github.com/bitwarden/clients.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b1f9d8e9f2a11e128d811b25f500ff8c5f3b1403b66d7d6b43e0bac9c55791d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b1f9d8e9f2a11e128d811b25f500ff8c5f3b1403b66d7d6b43e0bac9c55791d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b1f9d8e9f2a11e128d811b25f500ff8c5f3b1403b66d7d6b43e0bac9c55791d"
    sha256 cellar: :any_skip_relocation, sonoma:        "11a4044c2d6407e4ba53a962163d2528e2c20f6afa05cbfb7ab216870b9a55eb"
    sha256 cellar: :any_skip_relocation, ventura:       "11a4044c2d6407e4ba53a962163d2528e2c20f6afa05cbfb7ab216870b9a55eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b1f9d8e9f2a11e128d811b25f500ff8c5f3b1403b66d7d6b43e0bac9c55791d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b1f9d8e9f2a11e128d811b25f500ff8c5f3b1403b66d7d6b43e0bac9c55791d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false), "--ignore-scripts"
    cd buildpath/"apps/cli" do
      # The `oss` build of Bitwarden is a GPL backed build
      system "npm", "run", "build:oss:prod", "--ignore-scripts"
      system "npm", "install", *std_npm_args
    end
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"bw", "completion", "--shell", shells: [:zsh])
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end