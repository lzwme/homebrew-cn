class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https:github.comvultrvultr-cli"
  url "https:github.comvultrvultr-cliarchiverefstagsv3.4.0.tar.gz"
  sha256 "966161efc0f65c6f836503dfba9a3e2240ad6e54c76d83817fc99532808cf049"
  license "Apache-2.0"
  head "https:github.comvultrvultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5cef44b52842ad75fc500a57ca0530c985a17aef2ae19de28e87cd59e692ed2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5cef44b52842ad75fc500a57ca0530c985a17aef2ae19de28e87cd59e692ed2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5cef44b52842ad75fc500a57ca0530c985a17aef2ae19de28e87cd59e692ed2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2587c93489246ceeb188e6096791f48749f071017c74070b4596a25a58af34b7"
    sha256 cellar: :any_skip_relocation, ventura:       "2587c93489246ceeb188e6096791f48749f071017c74070b4596a25a58af34b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d59d5aee65a95ea740c5909b096be5d701cd4e353fdf01ea186c245cc6af6029"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"vultr", "version"
  end
end