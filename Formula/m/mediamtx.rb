class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.15.5",
      revision: "f1e3b373f53da1b554531460a101bf36f286a7fd"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0224d2691736c10632dc2d506cb25eda1ad3a6634ec52e4b8cc58a9420f3ce22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0224d2691736c10632dc2d506cb25eda1ad3a6634ec52e4b8cc58a9420f3ce22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0224d2691736c10632dc2d506cb25eda1ad3a6634ec52e4b8cc58a9420f3ce22"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb843ba60f14adad515e155b9c7464887f3d9abeeabefd8ed5cd74a9e1e389be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f154cccef6d2b56a7bf8ab5cda43523030820007d4e8c96cbe469ccdf637c379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d6b60b744a7d97c21fe6a22dd4a604ba6a33af93e2307a27278b16b4fe91383"
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