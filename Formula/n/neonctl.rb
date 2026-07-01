class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.28.0.tgz"
  sha256 "5404a4488235a4453812f105ff7c84ef463e15240a8ce7f4c7872e0e1973b0a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fa18f157a7927f7158d0cd896fbdbe8607e2c7645a99b7575c82de3adf70b6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fa18f157a7927f7158d0cd896fbdbe8607e2c7645a99b7575c82de3adf70b6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fa18f157a7927f7158d0cd896fbdbe8607e2c7645a99b7575c82de3adf70b6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0357886354f88073ed63b75321ebf2f04f09073e8ef77a9ff32ddcc5395e826c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeb9ce15009e606a55d89cedd0a018e7f7b226fe85f43636e220e938e2f2fec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00275370c50c2301be771870d8a540816e159e48a0e8539d4ddead1fc61e1cb5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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