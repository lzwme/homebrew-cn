class Maxwell < Formula
  desc "Reads MySQL binlogs and writes row updates as JSON to Kafka"
  homepage "https:maxwells-daemon.io"
  url "https:github.comzendeskmaxwellreleasesdownloadv1.42.1maxwell-1.42.1.tar.gz"
  sha256 "f26b367547678ed1968c43f154cf833c31827c5ecf7c3c6c9e6d734ee37ab429"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15dc74c740a6a571f9736a90eafdc584205137f85cd956d2f483f3afe474735d"
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