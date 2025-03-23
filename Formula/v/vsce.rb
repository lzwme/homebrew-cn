class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https:code.visualstudio.comapiworking-with-extensionspublishing-extension#vsce"
  url "https:registry.npmjs.org@vscodevsce-vsce-3.3.0.tgz"
  sha256 "62872641b49fc7ee306a0cf482a5815230d7f61f333fde2d2c1e5bc5acde8295"
  license "MIT"
  head "https:github.commicrosoftvscode-vsce.git", branch: "main"

  livecheck do
    url "https:registry.npmjs.org@vscodevscelatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "cc8e386c9ef456ea3f994750c5068b41dfeea997842199568bd09d44cb1930a3"
    sha256                               arm64_sonoma:  "db07f5a8784826ac05f4e44edf56ac51b58173271536e15f9e52e8ee893d7c6b"
    sha256                               arm64_ventura: "28083d90ccc596385b60b38c6b8430e69af847232a294f8bfd5dc8870002f9f7"
    sha256                               sonoma:        "5b8838497a1ba2bdf7506493648bb72da4568dda62b1b33347a80d7f0637725f"
    sha256                               ventura:       "66f34bda0af6336d57c0286c820c1c7c1cc8efd0becd340ebf8666cec2a4fe66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bea08838dc023a2f937482c38c45188b1e19eda2bc8a0fa386a3983896351b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d8ce19d34f6380c08188a1c4858e29953b0fd3831b3044861c73cbb78c9698"
  end

  depends_on "node"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec"bin*"]
  end

  test do
    error = shell_output(bin"vsce verify-pat 2>&1", 1)
    assert_match "Extension manifest not found:", error
  end
end