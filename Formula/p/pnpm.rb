class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.12.3.tgz"
  sha256 "e97173946a1f175e1d6c224527967a5f468b4821572faf6ac527fdecefac64cd"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32872b400613460d29c430d7ed3d5ad1e94815b278da34a167fa4b08253ea648"
    sha256 cellar: :any,                 arm64_sonoma:  "32872b400613460d29c430d7ed3d5ad1e94815b278da34a167fa4b08253ea648"
    sha256 cellar: :any,                 arm64_ventura: "32872b400613460d29c430d7ed3d5ad1e94815b278da34a167fa4b08253ea648"
    sha256 cellar: :any,                 sonoma:        "504ae9c03a3a5417fdbdff2abe58bb609473f5041504ea8c62665cb79efd9613"
    sha256 cellar: :any,                 ventura:       "504ae9c03a3a5417fdbdff2abe58bb609473f5041504ea8c62665cb79efd9613"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "338c9c7f8ef1380e2460a459d37c55d8b3635ad1401b03156d091d629c000ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "338c9c7f8ef1380e2460a459d37c55d8b3635ad1401b03156d091d629c000ab4"
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