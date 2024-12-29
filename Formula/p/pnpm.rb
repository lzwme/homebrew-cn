class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.15.2.tgz"
  sha256 "022309bb31359142b65bfa889e0406d2eebd5acfffca47e6944acf29d9d6a66b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "af6dbff032eddd7df4828c93b0ac553e71e1edc58a4cd7c59947deb75961257f"
    sha256 cellar: :any,                 arm64_sonoma:  "af6dbff032eddd7df4828c93b0ac553e71e1edc58a4cd7c59947deb75961257f"
    sha256 cellar: :any,                 arm64_ventura: "af6dbff032eddd7df4828c93b0ac553e71e1edc58a4cd7c59947deb75961257f"
    sha256 cellar: :any,                 sonoma:        "c3c9c9868f6dd53306f45b338144a6188e550bd9da5c8a6efa8a0d8102e0c854"
    sha256 cellar: :any,                 ventura:       "c3c9c9868f6dd53306f45b338144a6188e550bd9da5c8a6efa8a0d8102e0c854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1eb214f2f9aa9a66f72c2f8909be5ae74a6f1fd49be3d4134be3ef76dd1ef72"
  end

  depends_on "node" => [:build, :test]

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
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end