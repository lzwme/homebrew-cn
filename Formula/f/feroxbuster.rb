class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https:epi052.github.ioferoxbuster"
  url "https:github.comepi052feroxbusterarchiverefstagsv2.10.1.tar.gz"
  sha256 "d51dea67dcf33609aaa3e4e8e07f22c7c53866ff44fa4a68c02233cde95cead7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba5a1ea786951df8d846ac903f8fb21f00bb1e7d06032c4d0cb77776487ca036"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7202954b5205e5aa56fae63a76423135d77449a57770882d8bfe4c977dbbbd41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf43994fd3880fb79b59bce740721c0cfeef84359d2f65f2af3e8a08441815d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f60fc051fa7ee0a545ce4bc019424ac3d1a9016851abb3fca46caa7418f893a"
    sha256 cellar: :any_skip_relocation, ventura:        "c2f5f1c335df71b7c3ec072edadecaa3154aaad266a33f042467d4a9986722a3"
    sha256 cellar: :any_skip_relocation, monterey:       "717b5d857048ec0a74ed2d9000a098c661a02d81a59c02494aeb4332844df3b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10bf34271fd926aa88d528fec2141248c188bb818b7a4c48b714429cb1cb2d89"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "miniserve" => :test
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"wordlist").write <<~EOS
      a.txt
      b.txt
    EOS

    (testpath"web").mkpath
    (testpath"weba.txt").write "a"
    (testpath"webb.txt").write "b"

    port = free_port
    pid = fork do
      exec "miniserve", testpath"web", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 1

    begin
      exec bin"feroxbuster", "-q", "-w", testpath"wordlist", "-u", "http:127.0.0.1:#{port}"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end