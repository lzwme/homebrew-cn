class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.17.0.tgz"
  sha256 "7e46b15be4cdf79cd4d1e405bcf0eb9c94c9f8821111e7a35d35e5091b9b1bfc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97ec9873e001de0cc8c13b4524724149b0e6543e2282f42b9944d0bfad1619e7"
    sha256 cellar: :any,                 arm64_sequoia: "9d4a769d0c5fa495643c7d979c7a0128dad85067e5363a74384994fbd4966c79"
    sha256 cellar: :any,                 arm64_sonoma:  "9d4a769d0c5fa495643c7d979c7a0128dad85067e5363a74384994fbd4966c79"
    sha256 cellar: :any,                 sonoma:        "76c742f562960ebc613b270f1a15ff8c2193a34d01b6d34be77588de9d27d6f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91284fe4891a2b8b21495b251ab7251e052a53c2b0bafb6cba97e7dc6f12ec3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf00648e7bd0a5d9e38de2c4a8a564506cc92188c741be56cc3bf978fcc6624"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/neonctl/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end