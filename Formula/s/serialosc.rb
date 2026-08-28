class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://github.com/monome/docs/blob/gh-pages/serialosc/osc.md"
  # pull from git tag to get submodules
  url "https://github.com/monome/serialosc.git",
      tag:      "v1.4.8",
      revision: "c96ea389dbf82c84d17f6f7adddaf311aed49438"
  license "ISC"
  head "https://github.com/monome/serialosc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "13eec3424390309cf2fd022d89f10236ee9b0ff690783fbb617cdc4a0116fc0a"
    sha256 cellar: :any, arm64_sequoia: "c6876b51a57c4599f15f3bd2bc6e274004e21d071303ba5d364775eec57e4beb"
    sha256 cellar: :any, arm64_sonoma:  "caa20739fbe77124af848faf83605b62274fc33777b5f70a553200119a760289"
    sha256 cellar: :any, arm64_linux:   "fbf5efa296b342401c5e114a72e4d31e4f6238e842a8f163dbe48a5264cb782c"
    sha256 cellar: :any, x86_64_linux:  "bb5e6faa8e562f665dfe6790fe4153145d722050cc2c7c5e248e875df456064e"
  end

  depends_on "liblo"
  depends_on "libmonome"
  depends_on "libuv"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "avahi" => :no_linkage # dlopen("libdns_sd.so")
    depends_on "systemd" # for libudev
  end

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"
  end

  service do
    run [opt_bin/"serialoscd"]
    keep_alive true
    log_path var/"log/serialoscd.log"
    error_log_path var/"log/serialoscd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialoscd -v")
  end
end