class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://ghfast.top/https://github.com/semihalev/sdns/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "c9440216e74ec7d0510058c849bf86187175d65a4fa0817589135ca904e7b9ca"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64a3944a17cd0c7c65922b633e1cc5f279ddc1da31328a9bd9991f517d314d03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c80d1681b7b33f2230ae33fa195eff539b869d79c8b2c9a25ade508ff7c68fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e002af92779e40f4b848ae52c816e27902cdfb929d6c27850686d62f3807e82"
    sha256 cellar: :any_skip_relocation, sonoma:        "f21f779e845de8c64981b93035c1b18a7e5fed9b2b909463d0aa87d46ffa4489"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6765b3994617dc0a32f3bc42b4271260972b0fe428181e2049fb3bc44925e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d1793a0a04ab6217d7c0710c3969b114d04b2ce5d916254615d2723f550ee2b"
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