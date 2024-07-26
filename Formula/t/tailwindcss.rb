require "languagenode"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:github.comtailwindlabstailwindcssarchiverefstagsv3.4.7.tar.gz"
  sha256 "eec408a6ae90764c72d644f83cbf711749a895301dde1a34fe8b473dfbd40bca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d27c49f81d7235d86dfdacf4212bd5e541967e914e280e72771f3b201896f20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c50c6056c22a72b35374a30aa2a094b7c8c27a3900bb09d7d4dfb51679c4d88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c50c6056c22a72b35374a30aa2a094b7c8c27a3900bb09d7d4dfb51679c4d88"
    sha256 cellar: :any_skip_relocation, sonoma:         "bab433abcb45f14adf4612e2b7498b096e1fe80d3a0fc8787bbb9eaeba9a4168"
    sha256 cellar: :any_skip_relocation, ventura:        "0e4bb2e3d9f65a95e8e40545bc8d822750d880b8378e5a86ad223ead76485aea"
    sha256 cellar: :any_skip_relocation, monterey:       "9fb8c6304174372bd664c48945561b8dfeef522943495212576ce46159026a93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dbd40b813790067933d85ec9580cb85d3c55dfcca9b71958c39ebfd1ffce17b"
  end

  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"

    cd "standalone-cli" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
      os = OS.mac? ? "macos" : "linux"
      cpu = Hardware::CPU.arm? ? "arm64" : "x64"
      bin.install "disttailwindcss-#{os}-#{cpu}" => "tailwindcss"
    end
  end

  test do
    (testpath"input.css").write("@tailwind base;")
    system bin"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_predicate testpath"output.css", :exist?
  end
end