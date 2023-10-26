require "language/node"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://ghproxy.com/https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.3.5.tar.gz"
  sha256 "919da6a36e35774c247f807faef4ad4d972e7459e05d34b81d61e2861c83e00b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a110f6f7e549153d0545880bc6d04122e9485f05ff5eee81fd67c406032366f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10fcaaeafd3296b4906e45c14e99442136f1d4f4cfb2a775b8a8198605864813"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10fcaaeafd3296b4906e45c14e99442136f1d4f4cfb2a775b8a8198605864813"
    sha256 cellar: :any_skip_relocation, sonoma:         "509ebbdc4edda73ed34eaaf03f3ffcbecbe47a5154320efecfa2c1b8cabf5401"
    sha256 cellar: :any_skip_relocation, ventura:        "fe25dc140558046c15dde8eff511bd12001cd8026614d9ade5c96ff05d42eebb"
    sha256 cellar: :any_skip_relocation, monterey:       "fe25dc140558046c15dde8eff511bd12001cd8026614d9ade5c96ff05d42eebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d430caa57163d007caba42f02f5675fb691bdae4f982483c83ac59dd827c1501"
  end

  depends_on "node" => :build

  def install
    node = Formula["node"].opt_bin/"node"
    system node, "./scripts/swap-engines.js"

    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"

    cd "standalone-cli" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
      os = OS.mac? ? "macos" : "linux"
      cpu = Hardware::CPU.arm? ? "arm64" : "x64"
      bin.install "dist/tailwindcss-#{os}-#{cpu}" => "tailwindcss"
    end
  end

  test do
    (testpath/"input.css").write("@tailwind base;")
    system bin/"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_predicate testpath/"output.css", :exist?
  end
end