require "language/node"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://ghproxy.com/https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.3.4.tar.gz"
  sha256 "0c70e2c008db7537a0a584e506447ac48c6343fc7a9ecc610312cb88fa9962c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "681e936b5c8c3979e59d96d59652e7e5762997ea06a19d6d86c86112518b3549"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c247a79a646e4a258dc37a861a9af12773d2947daadb51d34093157ebcb7057c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c247a79a646e4a258dc37a861a9af12773d2947daadb51d34093157ebcb7057c"
    sha256 cellar: :any_skip_relocation, sonoma:         "25420fc1418b8a18d72e3b5db98e9cd683dc6650c11ea4b9b912de6ed1ce21df"
    sha256 cellar: :any_skip_relocation, ventura:        "f63b1a7fcad97c41f5062d59152c190ccae976d9f6301a001476dc7b7a3a6592"
    sha256 cellar: :any_skip_relocation, monterey:       "f63b1a7fcad97c41f5062d59152c190ccae976d9f6301a001476dc7b7a3a6592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ee7389456b7af45f906add1c96eb679e72166c7efcc12a210c6e34a51194921"
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