class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https:dystroy.orgdysk"
  url "https:github.comCanopdyskarchiverefstagsv2.10.0.tar.gz"
  sha256 "af6a19493f3ca1d471605cd3e40016aaf89d383c87705f6c32d8232b7e433c14"
  license "MIT"
  head "https:github.comCanopdysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "620f28a2fdc6ae12ce19aa83229dbae4361cd2de75266daa629aad90270dfc9f"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}dysk --version")
  end
end