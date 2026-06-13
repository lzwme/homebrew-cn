class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://ghfast.top/https://github.com/ferronweb/ferron/archive/refs/tags/2.8.0.tar.gz"
  sha256 "6132c50231a53d4f2ff9da3e8e69bc2c18c9493748845a045c7df06ae40df453"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop-2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e87ce26549af88af5f1ff4915889df0c31b204ea8648fc1ecffd857be1d487b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "104bf23a79cf4c4c9f7b4033d1efbcb2063878101d24b0498f529349ab9855a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98b19b1a0e6f23080a9041c3cc22b2ad6734341602a2b77daacd0e39b46a1eb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "51849858bba4289d893aa4bc73a94323d71fbb437f3b2c838fdab579eb642c2d"
    sha256 cellar: :any,                 arm64_linux:   "7ce8d6db5f74516a6401b47eaf76cd20a767ff9dcea10a647bdb88d2bae4e1d5"
    sha256 cellar: :any,                 x86_64_linux:  "197b3c2a374040ab6eac1ddd49d99334d2ef36a0e2089f363c3ac7637e373c20"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath/"ferron.yaml").write "global: {\"port\":#{port}}"
    begin
      pid = spawn bin/"ferron", "-c", testpath/"ferron.yaml"
      sleep 3
      assert_match "The requested resource wasn't found", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end