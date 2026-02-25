class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.30.2.tgz"
  sha256 "56121a083f0044fe06951ec2470978303f396ac62c549d68eb449c9467dfa0cf"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b9eefa3a2a3fd80f089670c2f58e1f2145a6881f30a1402896483a7b4569889"
    sha256 cellar: :any,                 arm64_sequoia: "4c9c457889cb1652397f5236c113fd5f9593a716bf6aa36ac4af1c5f6bf42d33"
    sha256 cellar: :any,                 arm64_sonoma:  "4c9c457889cb1652397f5236c113fd5f9593a716bf6aa36ac4af1c5f6bf42d33"
    sha256 cellar: :any,                 sonoma:        "766a464e90a64a1e7464772cd8323bf7c716e1382bffbbd63324f6fd2c84aa16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e5e18cfb40081845694b526e78780da732a431efd3d5d779968b00f59939e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e5e18cfb40081845694b526e78780da732a431efd3d5d779968b00f59939e83"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
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