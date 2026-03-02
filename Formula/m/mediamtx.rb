class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.16.3",
      revision: "9f94bd133392658eecb1f01b5363757ffac3380b"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "897c4f98adc30d6576ab4fbf8bcd48c7dc7a898d5d1446168e2dc3a440b39bde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "897c4f98adc30d6576ab4fbf8bcd48c7dc7a898d5d1446168e2dc3a440b39bde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "897c4f98adc30d6576ab4fbf8bcd48c7dc7a898d5d1446168e2dc3a440b39bde"
    sha256 cellar: :any_skip_relocation, sonoma:        "70c41112b9d2286511adea4ac3e454ae2851b4c7a0c3835729cedaa645bcb164"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e25198b3e36066be210ae7c9aac29d81320bf55baff0b38dc20b4b9f00043397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5635c4845c744dd358db74a3c887a383d964fa6afcf527bae30908b813292554"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install default config
    pkgetc.install "mediamtx.yml"

    (var/"log/mediamtx").mkpath
  end

  service do
    run [opt_bin/"mediamtx", etc/"mediamtx/mediamtx.yml"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/mediamtx/output.log"
    error_log_path var/"log/mediamtx/error.log"
  end

  test do
    port = free_port

    # version report has some issue, https://github.com/bluenviron/mediamtx/issues/3846
    assert_match version.to_s, shell_output("#{bin}/mediamtx --help")

    mediamtx_api = "127.0.0.1:#{port}"
    pid = spawn({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin/"mediamtx", pkgetc/"mediamtx.yml")
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http://#{mediamtx_api}/v3/config/global/get")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", pid)
    Process.wait pid
  end
end