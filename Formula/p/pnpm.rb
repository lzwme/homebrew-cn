class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.1.3.tgz"
  sha256 "740302fe768aaf1ba680c5213bd08983f219e0bcf0c96c0c6d7be393b8620c98"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ad1ed295f0da2ac3f4a37139a947e192c076c92eb4e687d36be1ef9c0737b52"
    sha256 cellar: :any,                 arm64_sequoia: "9108f841e00b36d279c9af10829f80aa827b678baa38f4a4e802e223ded043d5"
    sha256 cellar: :any,                 arm64_sonoma:  "9108f841e00b36d279c9af10829f80aa827b678baa38f4a4e802e223ded043d5"
    sha256 cellar: :any,                 sonoma:        "0e402fb74629c3e356b638e490828e164fe6e1d2e8d91d3690a1edb12ed6d0b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b123cedd6e33365d5a42c571704d5d8c44c3d4c4f08274e6fc658d9d5c901e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b123cedd6e33365d5a42c571704d5d8c44c3d4c4f08274e6fc658d9d5c901e2"
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