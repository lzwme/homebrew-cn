class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "7b35b6c14382ae1e26d92242373fbf3201bf0c6cb3df56f03ab3b99c14c20784"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "946e4221f76fb54c558347fa62ee85542abfc555f58e75205c47ac4a84f5510e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a94e54e51e6d3df3678616d9ec8aac3d9da3a0d05ab817291eaabc53218c5ae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4987b0a2f5c4e0b2153b98a23931684d2282cfd3d5d15aba24488435e157de4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f332a6d6b1ad96582ff657f8efceed66fde5ba2672d62f7db25f1084a8a6b35f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54b5e82f3aa323d539d0f9d1286857d4069fae510afcb12abcd72b9fd1896844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6286f5112b9f4ea60c7dbd966d64c4d7744971fd3d266bd67421ebb86950a69"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_path_exists testpath/"todo.txt"
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end