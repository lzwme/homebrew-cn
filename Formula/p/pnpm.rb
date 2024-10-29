class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.12.3.tgz"
  sha256 "24235772cc4ac82a62627cd47f834c72667a2ce87799a846ec4e8e555e2d4b8b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "82b4df5b54dc3ed0625cb565a548bab9bf266fc32fb39594fca7f01d27d7e634"
    sha256 cellar: :any,                 arm64_sonoma:  "82b4df5b54dc3ed0625cb565a548bab9bf266fc32fb39594fca7f01d27d7e634"
    sha256 cellar: :any,                 arm64_ventura: "82b4df5b54dc3ed0625cb565a548bab9bf266fc32fb39594fca7f01d27d7e634"
    sha256 cellar: :any,                 sonoma:        "165c2978f36342163a574bf7f8d662336064b52ef4b83e8e89d6ecc1897cfd7f"
    sha256 cellar: :any,                 ventura:       "165c2978f36342163a574bf7f8d662336064b52ef4b83e8e89d6ecc1897cfd7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4824e37648ae9fa38542a7a04e39f57d8bf9b0adb4443934ee29642156a13433"
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