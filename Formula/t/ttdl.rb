class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://ghfast.top/https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.19.1.tar.gz"
  sha256 "420bef5f8aa36af8e394ceb3790eb77262f81232e23f14b25dd2c56ebde699ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaefe967bcc93a775500a4b204764ae4ae80b4883150bc22d9c32aa195db4877"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e542dc3facdeb1a4d5f9d6673ec7718bc07049580621a073371a7e7b2104f143"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d22f1d749041cc877497a82c583d69ed95bd5ea7cf3be27efc39c3b89999e9f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fccf924f7967d2e62fcb62e0b633f0bb1528fb1f01254d2db6b5358b8efcd3ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "687c0536390762342694229957dd837c76b952b71fdfc73132c257a711ecb1f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93513538a442c1580e4f35c613e4be37a18a75779edc5d1734d0329d74c2c616"
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