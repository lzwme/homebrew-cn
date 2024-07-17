require "languagenode"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:github.comtailwindlabstailwindcssarchiverefstagsv3.4.6.tar.gz"
  sha256 "31bdf3fd34bbe5dd2cfb129349197199b134ad88debf9d26413c9369c2eaf39a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7623ad0095c26e1960af6880f7c4229df139ff11c4c28ca7b755b7643a312ec1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77a995050d92b4958fe5c3ab07ba624cb4ac25038fc8dc6c37f4d981266529ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77a995050d92b4958fe5c3ab07ba624cb4ac25038fc8dc6c37f4d981266529ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "00edcc3b48f9f625dc1c79e1080488d052464c94c6d3f14e7e438429e86ffdc2"
    sha256 cellar: :any_skip_relocation, ventura:        "b15245ca6d22b87225cf2f4721e11cce54c7ae8f578d7d53de7c2c04f8c69b90"
    sha256 cellar: :any_skip_relocation, monterey:       "fe5a8201bb42ec84927558842506c309587d0c9db6471143c8d64e8a62eec63a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cf50a1f360b90fd3c6019c3969005a964704b6e3a15d83b9ef7eee0b3184520"
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