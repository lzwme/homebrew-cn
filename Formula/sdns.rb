class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://ghproxy.com/https://github.com/semihalev/sdns/archive/v1.3.3.tar.gz"
  sha256 "653a873298c7d1eb2d658f7e39c328fd8127f7fc19e7a7854c0b1c0b60171505"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d1b37f7ad53c96352a2d24921524b5242c9ec8f02b2c646c40595b31153c476"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59b6b9c21ea216371074487fc0cb953516f62bf6fd7295de56fe97135c5ac64a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09e108a2452e290f08c61d2acefdb86c63c6d0c5a1822d0bd67cb5c3dd0d9954"
    sha256 cellar: :any_skip_relocation, ventura:        "1fc30b2d7c6d1ce2f1471b9aadc9899204d8ce86fb1585972f3f4bcd4f0a19f4"
    sha256 cellar: :any_skip_relocation, monterey:       "3f75429570df7026ba2a889fe998ab2a0a4e926e5159fe3b50054f492cf0b384"
    sha256 cellar: :any_skip_relocation, big_sur:        "02f18d72e2a1f21d51947f5029883bc2b8ebb6885d52b186074fd05f69d88ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee38404f4b0a6a3c023d8ce01ae52ce878bf54dd02f98af37484ad3d225e130"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin/"sdns", "-config", etc/"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var/"log/sdns.log"
    log_path var/"log/sdns.log"
    working_dir opt_prefix
  end

  test do
    fork do
      exec bin/"sdns", "-config", testpath/"sdns.conf"
    end
    sleep(2)
    assert_predicate testpath/"sdns.conf", :exist?
  end
end