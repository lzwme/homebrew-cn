class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https:github.comvaleriansaliousonic"
  url "https:github.comvaleriansaliousonicarchiverefstagsv1.4.9.tar.gz"
  sha256 "68f9336cd63e8f4171073be89e37ed6688812281207c3f70567b28fbe37be63b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eeac83f672962725f3217370f12b06582da32f38ac31198fff2dc0c3358f572"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51c1a32ae3da2966e4f943baf0b7553e2802f1354eae2029d6c840424531a697"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e35da6261442351069d3195082219065dc61e269cab9265cebfca2c57d94e97"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd0f9672179042b93dc1df50bdb4833f92a0fefe1085c37794748385fea62410"
    sha256 cellar: :any_skip_relocation, ventura:        "70c609372b8a30d3d6cbcd96dad191f60dd412dc9d787bcf64e0ce956b6cecb0"
    sha256 cellar: :any_skip_relocation, monterey:       "16e5f7de38eb2a531e7b844330dfcae8579f8602f71daec7050f9e9d1be5deb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "686d7ff993a9ee79e10de1fbf250c0a9eeb67048efaaff042bbc8b579e497524"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "netcat" => :test

  def install
    system "cargo", "install", *std_cargo_args
    inreplace "config.cfg", ".", var"sonic"
    etc.install "config.cfg" => "sonic.cfg"
  end

  service do
    run [opt_bin"sonic", "-c", etc"sonic.cfg"]
    keep_alive true
    working_dir var
    log_path var"logsonic.log"
    error_log_path var"logsonic.log"
  end

  test do
    port = free_port

    cp etc"sonic.cfg", testpath"config.cfg"
    inreplace "config.cfg", "[::1]:1491", "0.0.0.0:#{port}"
    inreplace "config.cfg", "#{var}sonic", "."

    fork { exec bin"sonic" }
    sleep 10
    system "nc", "-z", "localhost", port
  end
end