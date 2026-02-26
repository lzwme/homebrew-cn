class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.21.1.tgz"
  sha256 "081f8f16ab6a3f79ebe861dbe9435e3093b28395c54208de97bb8ca61f856614"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d5bfd4566d75cc2cbe54b21056426424725a709afc7b1847e558a3b57e56d94"
    sha256 cellar: :any,                 arm64_sequoia: "df86d45c403be3546b55e8472fe86e1cdb450de150580d01ea22874fa893adc1"
    sha256 cellar: :any,                 arm64_sonoma:  "df86d45c403be3546b55e8472fe86e1cdb450de150580d01ea22874fa893adc1"
    sha256 cellar: :any,                 sonoma:        "363d6dd7fe958030fcdd0e244eb377fad8e1026ae32ad6b57372bda53b887a0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37c7bc5c8551b4369253aff39cf882bbce3ab722d8377fa3eca2dcbcf41e0a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68ae5719dc96d4f229fd3aaf7b2887436bb087bc535a1ecfe8b1b9e6928cc4c6"
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