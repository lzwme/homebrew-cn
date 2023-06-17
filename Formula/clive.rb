class Clive < Formula
  desc "⚡ Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://ghproxy.com/https://github.com/koki-develop/clive/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "5808a8f3e80446f5517d8d24b7a1190bdfe2274b1340d2a65ee825e87c09a211"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1018fcbe05c5af9589fca2f96cdcdb3e3f3fc3556d2a4eef8ec6800f4f0a6021"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1018fcbe05c5af9589fca2f96cdcdb3e3f3fc3556d2a4eef8ec6800f4f0a6021"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1018fcbe05c5af9589fca2f96cdcdb3e3f3fc3556d2a4eef8ec6800f4f0a6021"
    sha256 cellar: :any_skip_relocation, ventura:        "1e05f356e1da43cdd8b698829f9683ad81b47cd901e3de25ada6ea82f05eda31"
    sha256 cellar: :any_skip_relocation, monterey:       "1e05f356e1da43cdd8b698829f9683ad81b47cd901e3de25ada6ea82f05eda31"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e05f356e1da43cdd8b698829f9683ad81b47cd901e3de25ada6ea82f05eda31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1706f314f64029dca9927962d9c53765d149b0ae9fdb715a12a804f02b4f4b57"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
  end

  test do
    system bin/"clive", "init"
    assert_predicate testpath/"clive.yml", :exist?

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end