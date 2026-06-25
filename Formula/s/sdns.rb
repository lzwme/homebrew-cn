class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://ghfast.top/https://github.com/semihalev/sdns/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "1847afad0c2fcc93d289306f48fb16050bb86040d3aef77d363c99ce3b513863"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f20ff9e5624eab996e8f1854a022ae9e7e6e3637b1e15ce696bdea3482a86485"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c44d194fb0232025cc9db88f2c2f718dfff7eb8182cae2497688a705e73b036b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36b6810218f4ff8436f278755675bcb78daffb392403d424ac3febeed4d6e70b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a00608c3ff309d16ac9565ec1a34fef94a71c79549f4b643b64b81b149db4df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "072ac4b75a98609e77d12aac3757dea927fa6a8a64136f0ec167067675208c48"
    sha256 cellar: :any,                 x86_64_linux:  "81bb0d5eddba9ef661ead252bdc9b7ad3f5fb19af0ad2ed43d21fcfc6c2832ce"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin/"sdns", "--config", etc/"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var/"log/sdns.log"
    log_path var/"log/sdns.log"
    working_dir opt_prefix
  end

  test do
    spawn bin/"sdns", "--config", testpath/"sdns.conf"
    sleep 2
    assert_path_exists testpath/"sdns.conf"
  end
end