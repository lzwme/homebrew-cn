class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.75.1.tgz"
  sha256 "e28a17acad79f24d26c75b977b83d5fe73c8814495d9be9bc5da79a7b068ca1d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "639a644d04b27445f294a9ed8aac4ecb58c15c780a953f21db3ae09874b0cdf5"
    sha256 cellar: :any,                 arm64_sequoia: "1fd6acee82a2792308d52ac737556c81817aa9031a4823685e362be2ae71da0c"
    sha256 cellar: :any,                 arm64_sonoma:  "1fd6acee82a2792308d52ac737556c81817aa9031a4823685e362be2ae71da0c"
    sha256 cellar: :any,                 sonoma:        "b4ad1104756905805c3e726e33408c5840c45adf3d0a86f47d21f533e65a4947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0396430e3d4f088319c3dbb7cf357452c3d8cca39fca1720e0913143fef9e04d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a8374f04d4c73b2df25d6cba3b7fbb955342f272ef28b4c0216c765697ebf28"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end