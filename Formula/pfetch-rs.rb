class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://ghproxy.com/https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "97b5163ee3224e8d68edf37a6b4cec9274d56e9e95c0d1c9f2ebfdb6b7821487"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31e43cc02314a77da45883fcd407622a7938a5987919a8c40bc99729012b8431"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b17820a9ec19aa170029b74970bf492801ca23fa184f6926ae808ae5e0f818"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c33feae7b7d34f91bfb31745a1c3f2b0e63d12d8d4a6dac726a712335432a057"
    sha256 cellar: :any_skip_relocation, ventura:        "60561e4a10b4dba56e25defca358eb5adc3ba05f9a0f6a2cf0136cc79099cb50"
    sha256 cellar: :any_skip_relocation, monterey:       "aec8b4151acfb10b76bc22bcc1a7da988acee1a6d067a026d5210159112aff61"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3248f30ee66e700ad1c635c2da33cc75e94c559d92ebbfe880cf83938d1e528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5419059eb0d10b7340610cdf1fd151693a37fa36bf9323d9ae36ab706039654"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end