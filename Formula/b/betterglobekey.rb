class Betterglobekey < Formula
  desc "Reworked Globe key for faster input source switching"
  homepage "https://github.com/Serpentiel/betterglobekey"
  url "https://ghfast.top/https://github.com/Serpentiel/betterglobekey/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "c4241735569fdfc698427e6c764cab111a591c19022f893506d85e261b67d23a"
  license "MIT"
  head "https://github.com/Serpentiel/betterglobekey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6c566abf974b1c6f564ae952dd9ae9b45174d30bf1e89ebc97dc93e5cd28808"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26e3de053cd6a5c54c58b602ffa2323a4ab2bf843d3a07cd734248afb3df6e54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e416110884136741cc139232a6cdd431edd1184e4e16e21d7b3f708b570236ca"
  end

  depends_on "go" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"betterglobekey", "completion")
  end

  service do
    run opt_bin/"betterglobekey"
    keep_alive true
    log_path var/"log/betterglobekey.log"
    error_log_path var/"log/betterglobekey.log"
  end

  test do
    list = shell_output("#{bin}/betterglobekey list")
    assert_match(/^com\.apple\.keylayout\./, list)
  end
end