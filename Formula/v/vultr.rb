class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://ghproxy.com/https://github.com/vultr/vultr-cli/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "98087cfad9913dc018bd011b9fa525dd519c287b5cd701f7c0529651e94a08af"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5961b75a39dc4a4327f555c7de01fdb37a18be8cc59c8826d945fcd1ad33c609"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a079aca4ee35b6b13dde2c2128b33ed0faf8d702116a8dd4f509a5b8f0eb0e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aca88e9a6813c96dfda7e9ad5a2cb31f91af49fbb95a41dab0fee2fe49f4a27"
    sha256 cellar: :any_skip_relocation, sonoma:         "1005bfae94c338c4d442a3a507002134813ef8cef2bd3d2abf08c662d05ab175"
    sha256 cellar: :any_skip_relocation, ventura:        "abaca17eee6441146311384b0bf1e20c1e9673fd93f70c5b435aefd09268ec74"
    sha256 cellar: :any_skip_relocation, monterey:       "26ea9134fd2afa366e42930cb3691ac7b7d48d542bffc7ff2f8feface001dcf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bd797ea1d7ce729a1f0b28ce1ccba35606cc0676df48fe9ecada4ecffbd3298"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"vultr", "version"
  end
end