class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://ghproxy.com/https://github.com/eycorsican/leaf/archive/v0.10.1.tar.gz"
  sha256 "81317dada57b57ab75556cf4b6d60cbabd7268c925c906c7f152942af11c8603"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2e5c30e2a36a9f9c286994a4c9b778f5f7aecdec7efc913e6faa74d8e56b971"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "088f5a85ccd0cad4121d88e31d677ebeb4e7ebd1ac9b49f7c7b69332b399dbe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da1fb496503529ea56d21925c7f8b882e4fe83fa1c4023e6997fa9ea68235467"
    sha256 cellar: :any_skip_relocation, ventura:        "614fd5107735934b745f8cba13125c7b418f0f1b3ea5c8c21de01a73d825e278"
    sha256 cellar: :any_skip_relocation, monterey:       "ca2766b5b8956dd880469afbf8fb83d889373bd14d6cdfed3eaabe2d834c83fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1812b7324ca0b87d7015fbfcde545b0201e23e91c1bd6fc1babbeb71e26e8655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "582972761f366a7dd035b5df9f6fa69142d7be22267d0dfdaeba5b0119c4a716"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    cd "leaf-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}/leaf -c #{testpath}/config.conf -t SS"

    assert_match "TCP failed: all attempts failed", output
  end
end