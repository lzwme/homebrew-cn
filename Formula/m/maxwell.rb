class Maxwell < Formula
  desc "Reads MySQL binlogs and writes row updates as JSON to Kafka"
  homepage "https:maxwells-daemon.io"
  url "https:github.comzendeskmaxwellreleasesdownloadv1.42.2maxwell-1.42.2.tar.gz"
  sha256 "21c3ce8ca5fbbcf90b52a0fb649e8303c954d293d337a3871af9cc158f84f641"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5dbc63965ab7e54be926df497dd23d377e391fee0fc5cd713d5b18e6ef35885f"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    %w[maxwell maxwell-bootstrap].each do |f|
      bin.install libexec"bin#{f}"
    end

    bin.env_script_all_files(libexec"bin", Language::Java.java_home_env("11.0"))
  end

  test do
    log = testpath"maxwell.log"

    fork do
      $stdout.reopen(log)
      $stderr.reopen(log)
      # Tell Maxwell to connect to a bogus host name so we don't actually connect to a local instance
      # The '.invalid' TLD is reserved as never to be installed as a valid TLD.
      exec "#{bin}maxwell --host not.real.invalid"
    end
    sleep 15

    # Validate that we actually got in to Maxwell far enough to attempt to connect.
    assert_match "CommunicationsException: Communications link failure", log.read
  end
end