class Scriptisto < Formula
  desc "Language-agnostic \"shebang interpreter\" to write scripts in compiled languages"
  homepage "https://github.com/igor-petruk/scriptisto"
  url "https://ghproxy.com/https://github.com/igor-petruk/scriptisto/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "478684778d3322109d9705e90caf87fbecc91364c9b6097f5979f81a60ea69e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34e6ed75f569b6e1555d425cd89a824dea04d56fdd60fa1795a74d9da1b4224f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfbda91101079978175c0312993d660e4ac9d57723bee0da34f646efcaeac281"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af8996db2527a2e465e40661ca4e4fa4b4ac50976c5f61f272d629d5af7d5a0b"
    sha256 cellar: :any_skip_relocation, ventura:        "3af5db071ffcd6419960df5630acab397d2c0734b20b382346319dae5838d51c"
    sha256 cellar: :any_skip_relocation, monterey:       "b457c169e83a86085ea5ec2b6bdbc210319a339fbd8296689b26ed8a2e8c1e7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "30e4596b9a539e169b8d57d11af5ada87d6fdf45a130ed4fdafcd478b1b631b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a095c8a3e896f4950462b8ed72d9368d38d2f19f924ea51c80a75df59f66b6f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #!/usr/bin/env scriptisto

      // scriptisto-begin
      // script_src: main.c
      // build_cmd: cc -O2 main.c -o ./script
      // scriptisto-end

      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/scriptisto ./hello-c.c")
  end
end