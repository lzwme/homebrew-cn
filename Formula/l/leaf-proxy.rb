class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://ghproxy.com/https://github.com/eycorsican/leaf/archive/v0.10.2.tar.gz"
  sha256 "83598b15b1215ca8425dede9accd34af047de3fb90d1f0acbc3c36cb1f364e68"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bd3ec30e430e0adcbcdf40164940fda099c6894a56332e44f5c442aba24d290"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "060caf483eaff007dc5cbc882d8bb88200473160c1e24770daa331e581cf93cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ebd7123be3696135faa97b17f68ebeeb828b01ad7067ef2efb54fad67bebdac"
    sha256 cellar: :any_skip_relocation, ventura:        "2077fe7c37807a9b3bea8dac631d95e0fc73638ac3ba1783126c4157d9bcc5a6"
    sha256 cellar: :any_skip_relocation, monterey:       "6311e94218390effd9dc9b70135d9bcfd139107dccd4b78ba86501c353255d4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b35c569c7df3a95d7821ca45e46d94a7635afc5bfdef14646d3c44cc4d9a1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e374244848d884b6779445882de37ed3dd99587d5b021cab4f486afe81663af"
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