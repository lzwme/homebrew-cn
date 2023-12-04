class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://ghproxy.com/https://github.com/cantino/mcfly/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "50902743810d7dbabd4037c8730aa9fc5205f5f704f14530260be846fc20dda6"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bff9ec2ac869d8c73352d7490d9c20ddcb75ac678eac65b1c3577ecd8573d1e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9d355d4853dcf0ecd9453ac7cd9e4e85f273a10e118c2125f76ca80e6794b00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dba88bbdcc6a50a7e2fee5306bc266e86bf6fa72f9e42ed3acaa517604164b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4f7d52cc5b4ebb14b977436715a24a35adc1e469a10aed482564c7bb7c13651"
    sha256 cellar: :any_skip_relocation, ventura:        "466d25a895a69a76260196ea2e6f9a5254b1e7c693e7307a7bc9b8cdd9be43a2"
    sha256 cellar: :any_skip_relocation, monterey:       "256c04aa780664771cfeb85cbeb4597309d3010d5f03362b407479b8aa093fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3582737af7eaa71082e906c42b8e91d02c9962d9f3eb8220b44616c36c747f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end