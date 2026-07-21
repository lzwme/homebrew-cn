class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.15.1.tgz"
  sha256 "27460629b10111604e7f98882753b53398986820c20e0a065f3a4a5e9e7db71f"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c8e6a14d20844601a207ca175080387cec8227426cdf7fc732cc45fba6871090"
    sha256 cellar: :any,                 arm64_sequoia: "c8e6a14d20844601a207ca175080387cec8227426cdf7fc732cc45fba6871090"
    sha256 cellar: :any,                 arm64_sonoma:  "c8e6a14d20844601a207ca175080387cec8227426cdf7fc732cc45fba6871090"
    sha256 cellar: :any,                 sonoma:        "61afe273ae53fe42ac56df8f6153a55db4016641ae73cdd08b22243a1f49aaa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8927eb8a1bac9d1dfd99aef1db2c8efb1878a8d12311681d209df1c34b6d50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8927eb8a1bac9d1dfd99aef1db2c8efb1878a8d12311681d209df1c34b6d50d"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("**/reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end