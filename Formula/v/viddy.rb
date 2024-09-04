class Viddy < Formula
  desc "Modern watch command"
  homepage "https:github.comsachaosviddy"
  url "https:github.comsachaosviddyarchiverefstagsv1.1.1.tar.gz"
  sha256 "4e95a57179037789dcf9bb98d3f31de3f01f9283ec2b63603ec92ab09a83bad2"
  license "MIT"
  head "https:github.comsachaosviddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "040df81b81eacfec2c04fbb5c927a942ce02ce06b9bc7b6e82908911b6bc6bdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "253c1f0a3e003f9777f0319a25a6abcc37ca246544efa62ee9c482df9aefd07a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c01a63dd3092366150e3a69d18e2abf57484cd87bc2948e9ce23ee17679ffe5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c117a9eb243b3733afa6cf8bd53673130d8c08fe3a127e451882458827fdb1e3"
    sha256 cellar: :any_skip_relocation, ventura:        "4b62347f1b6ffa0b88b70a2f6baa267945b37ced0beeed0628d3707f6aecf9f4"
    sha256 cellar: :any_skip_relocation, monterey:       "7cc61ee2a0ecb316b62ec84be14b2973eeaecb73beb595e6e1e21205015a4021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8648b2f653f5eb4ee6222bf5d06ddaf8c4f76250ab287491ccb639818be2f15"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Inputoutput error @ io_fread - devpts0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = fork do
        system bin"viddy", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}viddy --version")
  end
end