class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.15.0.tgz"
  sha256 "84c19e788d7d7ee248e4a6b7152f8ebba0f4fe7380a5f443ca17d76c030052d2"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6db411ecedcf6294fad86fdf67e5fd22d2a0f7ab4a858bd22b4f87701327e6ae"
    sha256 cellar: :any,                 arm64_sonoma:  "6db411ecedcf6294fad86fdf67e5fd22d2a0f7ab4a858bd22b4f87701327e6ae"
    sha256 cellar: :any,                 arm64_ventura: "6db411ecedcf6294fad86fdf67e5fd22d2a0f7ab4a858bd22b4f87701327e6ae"
    sha256 cellar: :any,                 sonoma:        "c540a16fc8a545f30e826b00caed33469b3521d8f842473cf3ae9516cb887c03"
    sha256 cellar: :any,                 ventura:       "c540a16fc8a545f30e826b00caed33469b3521d8f842473cf3ae9516cb887c03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c323a01445e164a28f31625b27c090701757083c03b50c252960d1479dac005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c323a01445e164a28f31625b27c090701757083c03b50c252960d1479dac005"
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
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end