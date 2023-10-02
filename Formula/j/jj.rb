class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://ghproxy.com/https://github.com/martinvonz/jj/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e9a96a840387910124edff477cbc05171acabc31c3436e14afaced96c7bda902"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4d3322a6e154fec92104fbee5e165df00c78c1e78cb066a848670b303dc36752"
    sha256 cellar: :any,                 arm64_ventura:  "0c913a21060e0cf9c4ec1cf8745cbe8bbb59d612ea44ebce835be0858e807d3f"
    sha256 cellar: :any,                 arm64_monterey: "9ee50f5485886316fefc882a4f44968dab6a10e5095e5727d26643cc9bf05abd"
    sha256 cellar: :any,                 arm64_big_sur:  "469aa8175e04e47e8198fa7fd6b7f38e1c9663821be82a1a0c0ee5e9a842e0ea"
    sha256 cellar: :any,                 sonoma:         "54ca45b65acba3fb28d5539f16ce728673afa4a8b7743e68fd1a93107b9970d9"
    sha256 cellar: :any,                 ventura:        "136aac0994d97a86d81c56d68c1dae250c851e27ab4edd9bf89a7b7133f42bd0"
    sha256 cellar: :any,                 monterey:       "6b83a20f487ee96748d69ccd336f08c9bb4d8cddd329d21b66a605d87e840ef8"
    sha256 cellar: :any,                 big_sur:        "82e61f3ce432fb2503bd3fd972e03395e6845bda3e3e2e0030e5abc3067b9fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa224d1cdf6a86cb1ce0fee002883cdc8debaf41c31bd0ae33e93fc8a0f6b30a"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"jj", "util", "completion", shell_parameter_format: :flag)
    (man1/"jj.1").write Utils.safe_popen_read(bin/"jj", "util", "mangen")
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?
  end
end