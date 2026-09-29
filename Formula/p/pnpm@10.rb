class PnpmAT10 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.34.6.tgz"
  sha256 "44d7db90fcbb2315b581f85989a913466765421fc656c28e80fac1b7ab5be456"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "6ae04c1bdbc48b2795cc37b8d12d07fc8911291ed5be555765a937a9a49ebdad"
    sha256 cellar: :any,                 arm64_tahoe:       "6ae04c1bdbc48b2795cc37b8d12d07fc8911291ed5be555765a937a9a49ebdad"
    sha256 cellar: :any,                 arm64_sequoia:     "6ae04c1bdbc48b2795cc37b8d12d07fc8911291ed5be555765a937a9a49ebdad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a8857898145a70c235a151a9ebc84fb2f3fc0c9b5ec1625d50bc3daba3003467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a8857898145a70c235a151a9ebc84fb2f3fc0c9b5ec1625d50bc3daba3003467"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@10"
    bin.install_symlink bin/"pnpx" => "pnpx@10"

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