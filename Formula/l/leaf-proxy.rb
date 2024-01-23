class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https:github.comeycorsicanleaf"
  url "https:github.comeycorsicanleafarchiverefstagsv0.10.9.tar.gz"
  sha256 "71f6e41f8673f33d8558403a85695dbd14b36663ea44f1a29ca8ba39de4db100"
  license "Apache-2.0"
  head "https:github.comeycorsicanleaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9e7642d6e9145f573870a921d6bfb34bdc53dc49e958912a74081ae940bc6ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a60fbbe01b74eb1f2bc03eb81f5c74cfd1988f5011b8d8c5dfec774f37290da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ae858e348b0e6e2351db0efc19494c0072d8c0a99ba86a07135773b6e685649"
    sha256 cellar: :any_skip_relocation, sonoma:         "360327f635c1a8551f86c5475c8013ff87933b54dd7001390acd75fcecd592d9"
    sha256 cellar: :any_skip_relocation, ventura:        "c6d193927481cf8aaaddcbd0dfc2ef4b711a6df694119726ac72413d9e17527c"
    sha256 cellar: :any_skip_relocation, monterey:       "b608921f9bc1645521372e47936b3d9dfce03ab38fb7c2eaa06af40ee8f2e52b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ace73643d9f65ccff49d88a82b4caaf95881d8847c0f97625a54df9e5e8f58b"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "leaf-bin")
  end

  test do
    (testpath"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}leaf -c #{testpath}config.conf -t SS"

    assert_match "TCP failed: all attempts failed", output
  end
end