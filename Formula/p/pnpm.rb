class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.13.1.tgz"
  sha256 "10012b57d23b9673bc534168ff56b1ac655ba4a2737ff37f6d9d19a55144afaa"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74b1c6d36bdefdc8512d8d630ab36db64a2dfe34eb266403536b013d58a77951"
    sha256 cellar: :any,                 arm64_sequoia: "74b1c6d36bdefdc8512d8d630ab36db64a2dfe34eb266403536b013d58a77951"
    sha256 cellar: :any,                 arm64_sonoma:  "74b1c6d36bdefdc8512d8d630ab36db64a2dfe34eb266403536b013d58a77951"
    sha256 cellar: :any,                 sonoma:        "7f0d0b05372b30df0e8ab4c5ea70fbf20193c3b8dc17152076990f2c5df6632c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05ef28f6892687719589f5b361cda5c7e8a9c7a2c030fbc0399157c1947711df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ef28f6892687719589f5b361cda5c7e8a9c7a2c030fbc0399157c1947711df"
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