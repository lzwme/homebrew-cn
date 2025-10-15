class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.18.3.tgz"
  sha256 "797d0059bc5fc3356d79c681615a137c7b35e4efc03a4449a8a1abfcbcc4bdc7"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95d626e9adf3629b97c4568e4901bb4ef40b162bc6f75157c3012c3445162184"
    sha256 cellar: :any,                 arm64_sequoia: "ad05eae9496623f76afb2aace862d3d3798501ae181e5aa7f42bb2041c01f1b7"
    sha256 cellar: :any,                 arm64_sonoma:  "ad05eae9496623f76afb2aace862d3d3798501ae181e5aa7f42bb2041c01f1b7"
    sha256 cellar: :any,                 sonoma:        "e17a63b425be5ec8696905fea1de64a1a78bb4a49574e6984c6c11d4293f2349"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a504723bae606bbb65c974dfede24c03bce3825f319b77346fc9fbb6ed907dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a504723bae606bbb65c974dfede24c03bce3825f319b77346fc9fbb6ed907dc"
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