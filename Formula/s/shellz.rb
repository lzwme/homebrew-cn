class Shellz < Formula
  desc "Small utility to track and control custom shellz"
  homepage "https://github.com/evilsocket/shellz"
  url "https://ghfast.top/https://github.com/evilsocket/shellz/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "3a89e3d573563a0c2ccb1831ff41fc0204c8b4efb011c10108ab98451a309b1c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e7da7409e05430d93aa136b8dbd83e40aa4ee2c8abb708606b27f5d42867096e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c129b18cdafdaa6f3cff5fef8bf0f4f76ef7d7b07a491e6cf7e3053a3169f06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f988ca6178c77343dfea20c9b4adf2eb0742605f4e0402dac2e2ad963ab5881c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac21c3ae7ea28b170bf5b3eb29b70ea61c512060807833de7ef1723a66316f6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4ea721956ec5e9a51e8774000f17eca688fdf50c1d41496b23f2be90bec65c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a54f8666f33b198599a417db0c241cd7176c4a95661fca1a643899863b3897b3"
    sha256 cellar: :any_skip_relocation, ventura:        "3145d8638bc906488ffff093a2d53829df20b80a48403d10c71e30d9ed3f4b89"
    sha256 cellar: :any_skip_relocation, monterey:       "fee1186791c0b7af5f978cd5170e0c1b1820cff57828e05d7b2274f93ff8f5f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc03abb302fea67ca26f25d3d5835ef5480865a77838ef84c02e652f89809d9a"
    sha256 cellar: :any_skip_relocation, catalina:       "5909f7cc0f0bfce0ad949965618ebf4a8cbdd022571bb89cfa44645d28dd72b0"
    sha256 cellar: :any_skip_relocation, mojave:         "d5a64a93fe05d1560dacb91290a5f77321d01872a8b4eb413823eadb92c74044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "562f9886f5574cec74ea7419dfb9e7ffc88cddf253da7971744781c115f0a0f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/shellz"
  end

  test do
    output = shell_output("#{bin}/shellz -no-banner -no-effects -path #{testpath}", 1)
    assert_match "creating", output
    assert_path_exists testpath/"shells"
  end
end