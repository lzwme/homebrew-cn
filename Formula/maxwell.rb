class Maxwell < Formula
  desc "Reads MySQL binlogs and writes row updates as JSON to Kafka"
  homepage "https://maxwells-daemon.io/"
  url "https://ghproxy.com/https://github.com/zendesk/maxwell/releases/download/v1.40.0/maxwell-1.40.0.tar.gz"
  sha256 "3e82aa067db89cc0dce8bcd6f4ca07852c6b19689af9562285386541e5b3e47c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e05f63cd8c39f3b843beebd99841e5e439f8fab503937188a9acd68dbfa638b7"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    %w[maxwell maxwell-bootstrap].each do |f|
      bin.install libexec/"bin/#{f}"
    end

    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("11.0"))
  end

  test do
    log = testpath/"maxwell.log"

    fork do
      $stdout.reopen(log)
      $stderr.reopen(log)
      # Tell Maxwell to connect to a bogus host name so we don't actually connect to a local instance
      # The '.invalid' TLD is reserved as never to be installed as a valid TLD.
      exec "#{bin}/maxwell --host not.real.invalid"
    end
    sleep 15

    # Validate that we actually got in to Maxwell far enough to attempt to connect.
    assert_match "CommunicationsException: Communications link failure", log.read
  end
end