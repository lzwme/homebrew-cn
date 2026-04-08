class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://ghfast.top/https://github.com/svenstaro/miniserve/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "b963f0226dd7fc8e66a70708da4f0747a3eef3763ea97b958d9d1d317362812d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5490779133bfb3cf53f52029496d27a0060462eb6be15a510377b90dc3e0e8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9020b9f0643c914dff10739681e4a6fcf398a111ca15b252e0e9a68593861039"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a48e15094e2694784453efd6ac835aa6e06ae8f4553b4c94d90e0a495bd93ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "a50e495c8ef408ed6da0ed2c3e3b5956751b9959a94b6e87cb9ea31e7bb4ead1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e08e23519e9d6764c13b5ddb55f88b673ac833a15e66c8607cddecb67eb4c30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcb7893f0f9bdb09d16f6270b403eb5d2a234672ef36f70c9a51f0ac2f214f3a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"miniserve", "--print-completions")
    (man1/"miniserve.1").write Utils.safe_popen_read(bin/"miniserve", "--print-manpage")
  end

  test do
    port = free_port
    pid = spawn bin/"miniserve", bin/"miniserve", "-i", "127.0.0.1", "--port", port.to_s

    begin
      sleep 2
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end