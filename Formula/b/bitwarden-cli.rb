class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://ghfast.top/https://github.com/bitwarden/clients/archive/refs/tags/cli-v2025.10.0.tar.gz"
  sha256 "e9f5b989e3403525c08ef0d295e7a315de2e5f05121e67b0352fed21417277df"
  license "GPL-3.0-only"
  head "https://github.com/bitwarden/clients.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47a5545f00c13d5eb5ffe36e4f9dfd9e4a5b44f0c5fb3694a144d5672e55cc6a"
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
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output
  end
end