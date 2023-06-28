class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://ghproxy.com/https://github.com/thedodd/trunk/archive/v0.17.0.tar.gz"
  sha256 "c545f54066b7bdbc25be381fa4f429ff8d41503e38c14eb723af792f836c336b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc949b69e8e8b0505fb61f2d423bcd7c608e57a6519d4df30e69384a23a38b83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4875d3b8b6d1137f40360a220b96d7b0abb48cff697e9fda5edb3ecda8ead879"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "109f63f0f36f8f17ce71fa27def0e3ed41e6c17e552fc4798b7dc085db226118"
    sha256 cellar: :any_skip_relocation, ventura:        "02be57c2870e5b4627b3f4d3ec3818b681b64d4ace0962d6b618fc106fab8589"
    sha256 cellar: :any_skip_relocation, monterey:       "b6298554b714b12d50e1cbb4acde41671b5463988c8c68e3994dda1b4f0be57e"
    sha256 cellar: :any_skip_relocation, big_sur:        "22be57bd01bd5d6dc53607cebcb6794873d4823fb3ad0fadc44bf59cef56267c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "704bfb76d5693d12829478b1595ad55a874444519c3e8019b78580760030e73b"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end