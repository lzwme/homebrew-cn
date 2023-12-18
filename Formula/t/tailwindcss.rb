require "languagenode"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:github.comtailwindlabstailwindcssarchiverefstagsv3.3.6.tar.gz"
  sha256 "9746285532d6ff9238869ab6afc7f94e067fb849a1ec3b14be53a1651261007b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd00b349687fb3479f32f054aae81a2aed1c5cd49369adcc686b8cbf734cddcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1e4bf3cb3569eaefef78e94f4ea9df2be344b98c7e69aa318aff11b81e9861a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1e4bf3cb3569eaefef78e94f4ea9df2be344b98c7e69aa318aff11b81e9861a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a645bafb7a21a347bb424394f60e83e6be6857e1991a5c0818431a94b1fbcab1"
    sha256 cellar: :any_skip_relocation, ventura:        "d86546e00d1e8c0044ddf6d380c599e3c31be6ded2e108202e85028b90102431"
    sha256 cellar: :any_skip_relocation, monterey:       "d86546e00d1e8c0044ddf6d380c599e3c31be6ded2e108202e85028b90102431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13ce2b95eec6b8540cc608b6d2d7a2e75bbec41c4fa6aae599cb6d0a06923747"
  end

  depends_on "node" => :build

  def install
    node = Formula["node"].opt_bin"node"
    system node, ".scriptsswap-engines.js"

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