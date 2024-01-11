require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2024.1.0.tgz"
  sha256 "0a4f2fd2b8b583952a4a448d13a6e7afb7dcb163a5526e8c9a92fbd80c459b97"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "632183d1394369bda56f0ffbd17ac711c83c59f8b11a9eb967d1b9dff16f0fc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0b1bf8834f59fbcc1e3c966bd5efd0a128279ec2eca6c3430c30b6c509e65ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "624e6799ca3810598917b2a6fbe353ca26cd3aeee156b753b47a2bc5c5bfe2d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "15dea1d9862cd64c63166de5d8fde457c39c1d65c11232ea607787dfb8aff901"
    sha256 cellar: :any_skip_relocation, ventura:        "b18cbe7f6c722403da16262068f6fa71391ed73ac505aa5e40488882cfafb728"
    sha256 cellar: :any_skip_relocation, monterey:       "88ecc43634b6ae94d9e9280a62ad76c1713228154e252cacd9d49b4a22b42ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc34d399b34eeab88ae3d6dcfb096ec54c966d70463be2e2ca32d616ac558c08"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(bin/"bw", "completion", shell_parameter_format: :arg, shells: [:zsh])
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end