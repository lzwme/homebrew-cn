class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.2.1.tgz"
  sha256 "f243199f6a0f64bd3c620797ce921a0fceded02530ed3165db226711c6331a19"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e1d1732b5ab30bf747769010266d5b0340d8caebc8072b3cc02da44c3009fae"
    sha256 cellar: :any,                 arm64_sequoia: "9e1d1732b5ab30bf747769010266d5b0340d8caebc8072b3cc02da44c3009fae"
    sha256 cellar: :any,                 arm64_sonoma:  "9e1d1732b5ab30bf747769010266d5b0340d8caebc8072b3cc02da44c3009fae"
    sha256 cellar: :any,                 sonoma:        "8f71e36162ec7db1d7d42867cff0eba7b8b9daefa39c06c47e1f682b8687a153"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b41f293b6f8556257d705bd7bd17cf0df85310cb19d33b6242bb19bd6fdbea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f550d6cfddf2d9f91a481e26828d5c2a466302b7d5bd1309db6305a586fa9f2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end