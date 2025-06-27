class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.12.4.tgz"
  sha256 "cadfd9e6c9fcc2cb76fe7c0779a5250b632898aea5f53d833a73690c77a778d9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6482b264d7f9f15383f6aedc856c9b745f48e1d819dc63f932de1d4b0a7e7aa"
    sha256 cellar: :any,                 arm64_sonoma:  "f6482b264d7f9f15383f6aedc856c9b745f48e1d819dc63f932de1d4b0a7e7aa"
    sha256 cellar: :any,                 arm64_ventura: "f6482b264d7f9f15383f6aedc856c9b745f48e1d819dc63f932de1d4b0a7e7aa"
    sha256 cellar: :any,                 sonoma:        "1ec9276b0f0cbaadf9a3d866f36ef084d5c00dc65283fb08b56fc7e7d651b359"
    sha256 cellar: :any,                 ventura:       "1ec9276b0f0cbaadf9a3d866f36ef084d5c00dc65283fb08b56fc7e7d651b359"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6de72928cd67c7fceb4770226c314e73907c373d192a473b6f5033ce584c22fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6de72928cd67c7fceb4770226c314e73907c373d192a473b6f5033ce584c22fb"
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