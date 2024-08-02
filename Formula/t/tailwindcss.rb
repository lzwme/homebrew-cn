class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:github.comtailwindlabstailwindcssarchiverefstagsv3.4.7.tar.gz"
  sha256 "eec408a6ae90764c72d644f83cbf711749a895301dde1a34fe8b473dfbd40bca"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea7e52e250d828c24b90cdb44ea2af1a3d81f183799308849bf46ae724a80628"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d12ddea4769651fb5bbbb9fd11ef15ce3d2ab651f4eeed69bc05877fd42cb762"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d12ddea4769651fb5bbbb9fd11ef15ce3d2ab651f4eeed69bc05877fd42cb762"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d53668104032e97a84d365ad86e40d42457b70477f53c7977114970ff585a96"
    sha256 cellar: :any_skip_relocation, ventura:        "5eef39fef7a8fe4cb1b267a8cc05bd98c64ef9b6f28a151fb524ef381143894c"
    sha256 cellar: :any_skip_relocation, monterey:       "5eef39fef7a8fe4cb1b267a8cc05bd98c64ef9b6f28a151fb524ef381143894c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "839ac55cc5938312b8146b1825788ddaa244e009fe04f5f912327c8be5789e6b"
  end

  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    cd "standalone-cli" do
      system "npm", "install", *std_npm_args(prefix: false)
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